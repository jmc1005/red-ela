enum UserType {
  patient('patient', 'Paciente'),
  caregiver('caregiver', 'Cuidador'),
  doctor('doctor', 'Profesional');

  const UserType(this.value, this.label);

  final String value;
  final String label;
}
