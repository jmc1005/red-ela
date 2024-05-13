enum UsuarioTipo {
  admin('admin'),
  paciente('paciente'),
  cuidador('cuidador'),
  gestorCasos('gestor_casos'),
  // gestor('gestor'),
  ;

  const UsuarioTipo(this.value);

  final String value;
}
