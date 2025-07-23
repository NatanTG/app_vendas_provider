/// Funções utilitárias compartilhadas

/// Exemplo: formata preço para moeda brasileira
String formatCurrency(double value) {
  return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
}
