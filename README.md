# RedELA (Red Esclerósis Lateral Amiotrófica)

Proyecto creado con flutter con el patrón de arquitectura MVVM, también conocido como Model View ViewModel que se centra en separar la interfaz del usuario (View) de la parte lógica (Model). La interacción entre la parte lógica y la interfaz del usuario a través del recurso ViewModel.
Algunas de las ventajas al usar este patrón son:
* Fácil desarrollo ya que al poder separar la vista de la lógica varios equipos pueden trabajar simultáneamente en varios componentes.
* Fácil testeo ya que no es necesario utilizar la vista para crear tests para el model o el viewmodel.
* Fácil mantenimiento ya que al realizar la separación de los componentes se crea un código simple y limpio.

Esta aplicación gestiona las citas con los especialistas, los materiales ortoprotésicos, ensayos y unidades ELA.

En la primera versión se centrará en la gestión de citas que generarán los gestores de casos, estas citas podrán ser visibles por el gestor de casos que las crea y por los pacientes a quien son asignados, pudiendo verlas también los cuidadores de los pacientes.  

[![Deploy to Firebase Hosting on merge](https://github.com/jmc1005/red-ela/actions/workflows/firebase-hosting-merge.yml/badge.svg)](https://github.com/jmc1005/red-ela/actions/workflows/firebase-hosting-merge.yml)

## local deploy
Run web
```
dart run build_runner build; flutter pub get;
flutter run -d chrome;
```

