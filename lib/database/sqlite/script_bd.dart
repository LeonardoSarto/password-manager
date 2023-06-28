class ScriptBd {

  static const createTableCredentials = '''
   CREATE TABLE credentials(
    id INTEGER NOT NULL PRIMARY KEY,
    login VARCHAR(200) NOT NULL,
    password VARCHAR(200) NOT NULL,
    created_in DATETIME,
    updated_in DATETIME,
    account_id INTEGER NOT NULL,
    FOREIGN KEY (account_id) REFERENCES account (id)
   )''';

  static const createTableAccount = '''
   CREATE TABLE account(
    id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    social_media VARCHAR(200),
    created_in DATETIME,
    updated_in DATETIME
   )''';

  static const insercaoCursos = [
    '''
    INSERT INTO curso (nome, ano, imagem)
    VALUES ('Engenharia de Software','2023', 'https://www.storm.am/wp-content/uploads/2019/07/desenvolvimento-de-software.png')
    ''',
    '''
    INSERT INTO curso (nome, ano, imagem)
    VALUES ('Engenharia Elétrica','2023', 'https://www.just4offices.com.br/wp-content/uploads/2020/10/eletrica.png')
    ''',
    '''
    INSERT INTO curso (nome, ano, imagem)
    VALUES ('Licensiatura em Química','2023', 'https://static.todamateria.com.br/img/categories/quimica.png')
    '''];

  static const insercoesAluno = [
    '''
    INSERT INTO aluno (nome, telefone, email, cpf)
    VALUES ('Pietro','(11) 9 9874-5656','pietro@email.com','097.560.179-29')
    ''',
    '''
    INSERT INTO aluno(nome, telefone, email, cpf)
    VALUES ('Maitê','(11) 9 9632-8578', 'maite@email.com','097.560.179-29')
    ''',
    '''
    INSERT INTO aluno (nome, telefone, email, cpf)
    VALUES ('Hortência','(11) 9 9562-3356','hortencia@email.com','097.560.179-29')
    '''];
}