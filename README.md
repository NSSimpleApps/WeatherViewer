# WeatherViewer
A simple weather viewer.

THIS APPLICATION NOT WORKING NOW BECAUSE WEATHER GOOGLE SERVICE HAS BEEN REMOVED.
Maybe it will be fixed in future.

Я сначала использовал данные с сайта `http://openweathermap.org`.

Переписал библиотеку `OpenWeatherMapAPI`, потому что она использовала старую версию `AFNetworking`.
Потом подключил библиотеку `JSONModel`, создал модель, отвечающую данным, приходящим с сервера.
Но мне так надоело бороться с построением оптимальной сетки (нужно искать преимущественно города) в зависимости от зума и аннотациями,
поэтому теперь программа просто тянет изображения с гугловского сервера и рендерит их.


![Alt text](https://github.com/NSSimpleApps/WeatherViewer/blob/master/WeatherViewer/WeatherViewer.gif)

