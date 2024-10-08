
import 'package:flutter/material.dart';

class Components {
    IconData iconePrioridade(String prioridade){
    switch(prioridade){
      case'Baixa':
      return Icons.low_priority;
      case'Media':
      return Icons.priority_high;
      case'Alta':
      return Icons.warning;
      case'todosPri':
      return Icons.help_outline;
      case'todos':
      return Icons.filter_list;
      case'completos':
      return Icons.check_box;
      case'incompletos':
      return Icons.check_box_outline_blank;
      default:
      return Icons.help_outline;
    }
  }
}