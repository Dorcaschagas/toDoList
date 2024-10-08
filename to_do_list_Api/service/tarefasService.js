const _query = require('../data/query/tarefasQuery.js');

exports._getTarefass = async function(fields){
	return await _query._getTarefass(fields);
};

exports._getTarefas = async function(id, fields){
	return await _query._getTarefas(id, fields);
};

exports._postTarefas = async function(fields){
	return await _query._postTarefas(fields);
};

exports._putTarefas = async function(id, fields){
	return await _query._putTarefas(id, fields);
};

exports._deleteTarefas = async function(id){
	return await _query._deleteTarefas(id);
};

