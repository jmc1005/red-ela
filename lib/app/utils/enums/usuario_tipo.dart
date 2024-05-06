enum UsuarioTipo {
  paciente('paciente'),
  cuidador('cuidador'),
  // gestorCasos('gestor_casos', 'Enfermero/a gestor/a casos'),
  // gestor('gestor', 'Gestor artículos investigación y ensayos'),
  // admin('admin', 'Administrador')
  ;

  const UsuarioTipo(this.value);

  final String value;
}
