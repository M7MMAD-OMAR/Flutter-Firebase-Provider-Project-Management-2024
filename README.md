# project_management_muhmad_omar

A new Flutter project.

## Getting Started
1- src -
2- constants - All the application level constants are defined in this directory with-in their respective files. This directory contains the constants for  `api endpoints`, `preferences` and analytics constants
3- models - The models folder contains files each with a custom class of an object widely used throughout the app
4- providers - Contains store(s) for state-management of your application, to connect the reactive data of your application with the UI.
5- screens — The screens folder holds many different folders, each of which corresponds to a different screen of the app. Each screen folder holds two things: a primary screen file and widgets which would be used only inside a particular screen should be placed inside that screen and not inside the common widgets folder.
6- services - This would handle all network and business logic of your application.
7- util — Contains the utilities/common functions of your application.For example, Showing dates format, Currency in proper format, Network check etc..
8- widgets — Contains the common widgets for your applications. For example, Button, TextField, etc..
9- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
10- providers.dart — This file contains all the providers for your application.
11- routes.dart — This file contains all the routes for your application.




**src**

This directory contains all the code of the application.

**constants**

This directory contains all the application level constants. A separate file is created for each type as shown in the example below:

constants/
|- analytics.dart
|- api-names.dart
|- constants.dart
|- endpoints.dart
|- preferences.dart

**models**
This directory contains files each with a custom class of an object widely used throughout the app

models/
|- models-name
providers
This directory contains state-management of your application, to connect the reactive data of your application with the UI.

providers/
|- name-provider.dart
screens
This directory contains all the screens of your application. Each screen is located in a separate folder making it easy to combine a group of files related to that particular screen. All the screen-specific widgets will be placed in widgets the directory as shown in the example below:

screen/
|- screen-name
|- screen-name.dart
|- widgets
|- widget-name.dart
utils
It contains the common file(s) and utilities used in a project. The folder structure is as follows:

utils/
|- validator
|- form-validator.dart
widgets
It contains the common widgets that are shared across multiple screens. For example, Button, TextField, etc.

widgets/
|- name_widget.dart

