enum UsuarioEstado {
  validacion('validacion'),
  activo('activo'),
  inactivo('inactivo'),
  ;

  const UsuarioEstado(this.value);

  final String value;
}
