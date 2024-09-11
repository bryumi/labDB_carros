const oracledb = require('oracledb');

async function testConnection() {
  let connection;

  try {
    connection = await oracledb.getConnection({
      user: 'bruna',
      password: 'senha',
      connectString: 'localhost:1521/XEPDB1'
    });

    console.log('Conexão estabelecida com sucesso.');

    // Execute a consulta simples para testar a conexão
    const result = await connection.execute(`SELECT * FROM dual`);
    console.log('Consulta realizada com sucesso:', result.rows);

  } catch (err) {
    console.error('Erro na conexão:', err);
  } finally {
    if (connection) {
      try {
        await connection.close();
        console.log('Conexão fechada.');
      } catch (err) {
        console.error('Erro ao fechar a conexão:', err);
      }
    }
  }
}

testConnection();