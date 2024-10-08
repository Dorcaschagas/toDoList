const _express = require("express");
const _route = _express.Router();
const _tarefasService = require("../service/tarefasService.js");

_route.get("/tarefass", async function (req, res) {
  const { fields } = req.query;
  var _result = await _tarefasService._getTarefass(fields);
  res.status(200).json(_result);
});

_route.get("/tarefas/:id", async function (req, res) {
  const { id } = req.params;
  const { fields } = req.query;
  var _result = await _tarefasService._getTarefas(id, fields);
  res.status(200).json(_result);
});

_validaFormulario = [
  // body('titulo'),body('descricao'),body('status'),body('createdAt'),body('prioridade'),body('grupo')
];
_route.post("/tarefas", _validaFormulario, async (req, res) => {
  console.log(req.body);
  const _result = await _tarefasService._postTarefas(req.body);
  res.status(201).json(_result);
});

_route.put("/tarefas/:id", _validaFormulario, async (req, res) => {
  const { id } = req.params;
  const _result = await _tarefasService._putTarefas(id, req.body);
  res.status(201).json(_result);
});

_route.delete("/tarefas/:id", async (req, res) => {
  const { id } = req.params;
  const _result = await _tarefasService._deleteTarefas(id);
  res.status(201).json(_result);
});

module.exports = _route;
