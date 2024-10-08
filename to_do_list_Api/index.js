require("express-async-errors"); // CANALIZA OS CALLBACK DE ERROS EXPRESS
require("dotenv").config();

var path = require("path");

const express = require("express");
const fileUpload = require("express-fileupload");
const app = express();
var compression = require("compression");
const bodyParser = require("body-parser"); //TRADA DADOS DE FORMULARIOS
const cors = require("cors");

/////////  IMPORTAR ROTAS DE API DE TERCEIROS ///////////////

app.use(bodyParser.urlencoded({ extended: true, limit: "50mb" }));
app.use(bodyParser.json({ limit: "50mb" }));
app.use(express.json());
app.use(compression());
app.use(cors());
app.use(fileUpload({ limits: { fileSize: 50 * 1024 * 1024 } }));

//SERVIDOR WEB NA PASTA VIEW
app.use(express.static(__dirname + "/views"));
app.get("/", function (req, res) {
  res.sendFile(path.join(__dirname + "/views/index.html"));
  console.log("abrindo pagina");
});

//ROTAS
const routerTarefas = require("./route/tarefasRoute.js");
app.use("/todoList", routerTarefas);
//CREATE TABLE _tarefas (id SERIAL PRIMARY KEY, titulo VARCHAR(255), descricao VARCHAR(255), status INTEGER, createdAt VARCHAR(255), prioridade VARCHAR(255), grupo VARCHAR(255));

app.listen(52461, async () => {
  console.log(`Servidor rodando na porta http://localhost:${52461}`);
});
