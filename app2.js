const fs = require('fs');
const csv = require('csv-parser');
const oracledb = require('oracledb');

// Função para verificar ou inserir os combustíveis
async function getOrCreateCombustivel(connection, combustivelNome) {
  const result = await connection.execute(
    `SELECT com_id FROM combustiveis WHERE com_nome = :nome`,
    [combustivelNome]
  );

  if (result.rows.length > 0) {
    return result.rows[0][0]; // Retorna o com_id
  }

  // Se não encontrar, insere e retorna o novo ID
  const insertResult = await connection.execute(
    `INSERT INTO combustiveis (com_nome) VALUES (:nome) RETURNING com_id INTO :id`,
    { nome: combustivelNome, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
    { autoCommit: true }
  );

  return insertResult.outBinds.id[0]; // Retorna o com_id inserido
}

// Função para verificar ou inserir as marcas
async function getOrCreateMarca(connection, marcaNome) {
  const result = await connection.execute(
    `SELECT mar_id FROM marcas WHERE mar_nome = :nome`,
    [marcaNome]
  );

  if (result.rows.length > 0) {
    return result.rows[0][0]; // Retorna o mar_id
  }

  // Se não encontrar, insere e retorna o novo ID
  const insertResult = await connection.execute(
    `INSERT INTO marcas (mar_nome) VALUES (:nome) RETURNING mar_id INTO :id`,
    { nome: marcaNome, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
    { autoCommit: true }
  );

  return insertResult.outBinds.id[0]; // Retorna o mar_id inserido
}
async function getOrCreateMotor(connection, motorDescricao) {
    const result = await connection.execute(
      `SELECT mot_id FROM tipos_motor WHERE mot_descricao = :descricao`,
      { descricao: motorDescricao }
    );
  
    if (result.rows.length > 0) {
      return result.rows[0][0];
    }
  
    const insertResult = await connection.execute(
      `INSERT INTO tipos_motor (mot_descricao) VALUES (:descricao) RETURNING mot_id INTO :id`,
      { descricao: motorDescricao, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
  
    return insertResult.outBinds.id[0];
  }
  async function getOrCreateCambio(connection, cambioNome) {
    const result = await connection.execute(
      `SELECT cam_id FROM tipos_cambio WHERE cam_nome = :nome`,
      [cambioNome]
    );
  
    if (result.rows.length > 0) {
      return result.rows[0][0]; 
    }
    const insertResult = await connection.execute(
      `INSERT INTO tipos_cambio (cam_nome) VALUES (:nome) RETURNING cam_id INTO :id`,
      { nome: cambioNome, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
  
    return insertResult.outBinds.id[0]; // Retorna o mar_id inserido
  }
// Função para inserir ou verificar os modelos
async function getOrCreateModelo(connection, modeloData) {
  const result = await connection.execute(
    `SELECT mod_id FROM modelos WHERE mod_nome = :nome`,
    [modeloData.nome]
  );

  if (result.rows.length > 0) {
    return result.rows[0][0]; // Retorna o mod_id
  }

  // Se não encontrar, insere e retorna o novo ID
  const insertResult = await connection.execute(
    `INSERT INTO modelos (mod_nome, mod_fipe_cod, mod_mar_id, mod_cam_id, mod_mot_id, mod_com_id)
     VALUES (:nome, :fipe, :marca, :cambio, :motor, :combustivel)
     RETURNING mod_id INTO :id`,
    {
      nome: modeloData.nome,
      fipe: modeloData.fipe,
      marca: modeloData.marca,
      cambio: modeloData.cambio,
      motor: modeloData.motor,
      combustivel: modeloData.combustivel,
      id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
    },
    { autoCommit: true }
  );

  return insertResult.outBinds.id[0]; // Retorna o mod_id inserido
}

// Função para inserir os preços dos veículos
async function insertVeiculoPreco(connection, veiculoData) {
  const result = await connection.execute(
    `INSERT INTO veiculos_preco (vei_autentica_cod, vei_media_preco, vei_ano_fab, vei_anos_de_uso, vei_mod_id)
     VALUES (:autentica, :preco, :ano_fab, :anos_uso, :mod_id)`,
    {
      autentica: veiculoData.autentica_cod,
      preco: veiculoData.media_preco,
      ano_fab: veiculoData.ano_fab,
      anos_uso: veiculoData.anos_uso,
      mod_id: veiculoData.mod_id
    },
    { autoCommit: true }
  );

  console.log("Veículo inserido:", result.rowsAffected);
}

async function processCSV() {
    let connection;
    try {
      connection = await oracledb.getConnection({
        user: "bruna",
        password: "senha",
        connectString: "localhost:1521/XEPDB1"
      });
  
      console.log("Conectado ao Oracle Database");
  
      const filteredData = [];
  
      // Wrap the CSV reading in a Promise
      await new Promise((resolve, reject) => {
        fs.createReadStream('fipe_2022.csv')
          .pipe(csv())
          .on('data', (row) => {
            if (row.year_of_reference === '2022' && row.month_of_reference === 'January') {
              filteredData.push(row);
            }
          })
          .on('end', () => {
            console.log("Dados filtrados prontos para inserção.");
            resolve();
          })
          .on('error', (err) => {
            reject(err);
          });
      });
  
      // Iterar sobre os dados filtrados
      for (const row of filteredData) {
        const combustivelId = await getOrCreateCombustivel(connection, row.fuel);
        const marcaId = await getOrCreateMarca(connection, row.brand);
        const motorId = await getOrCreateMotor(connection, row.engine_size);
        const cambioId = await getOrCreateCambio(connection, row.gear);
        const modeloId = await getOrCreateModelo(connection, {
          nome: row.model,
          fipe: row.fipe_code,
          marca: marcaId,
          cambio: cambioId,
          motor: motorId,
          combustivel: combustivelId
        });
  
        await insertVeiculoPreco(connection, {
          autentica_cod: row.authentication,
          media_preco: parseFloat(row.avg_price_brl),
          ano_fab: parseInt(row.year_model),
          anos_uso: parseInt(row.age_years),
          mod_id: modeloId
        });
      }
  
      console.log("Inserção concluída.");
    } catch (err) {
      console.error("Erro:", err);
    } finally {
      if (connection) {
        try {
          await connection.close();
        } catch (err) {
          console.error("Erro ao fechar a conexão:", err);
        }
      }
    }
  }

processCSV();
