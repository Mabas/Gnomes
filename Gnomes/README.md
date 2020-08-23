Arquitectura

Al ser una aplicación muy pequeña y con varias pantallas y flujos reutilizables, se decidió usar una estrategía con Coordinators

Ya que no requiere demasiado código de setup, y tengo algunas utilerías para facilitar el inicio

Utilerías usadas

Se no se uso ninguna dependencia de terceros, sin embargo en el folder KMTools se encuentran algunasutilerías que desarrolle como ejemplo en un cursó que impartí hace un par de meses

- Networking
Una capa ligera implementada mediante protocolos, dado que esta aplicación solo cuenta con una petición, me pareció pertinente su uso

CDStack
Una abstracción para usar CoreData en background

Coordinator, DataSource, Storyboarded
Inspirados en:
How to use the coordinator pattern
https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps
de Pul Hudson @twostraws

Con algunas implementaciones que se ajustan a mi estilo de desarrollo





