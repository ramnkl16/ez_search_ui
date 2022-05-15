# Ez search UI 
I started learning [go](https://go.dev/) and got a chance to use [boltdb](https://github.com/boltdb/bolt). Started using it for one of our sync tool (hybris to siteocre integration) to keep product information as local storage on the server. I impressed much on performance (both read and write) from json data on the server local storage along with [bleve](http://blevesearch.com/docs/Home/). Able to search  top 50 records about 100 ms from 3 minilion of records. 
Thought of use it for app and integration logs, So Started build rest api for read and write the json data. This app uses those rest api to get the data from bleve indexes. Also build a query parse engine for traditional sql query which translate the sql query to bleve api search query. Ez search golang  source code is available [here](https://github.com/ramnkl16/ez-search). Before run search explorer rest api service should start either from locar or server. 

By default flutter app can be isntalled any of the platform (Windows, Android, IOS, web and linux)
authentication screen shot
![auth](https://user-images.githubusercontent.com/19195181/168491841-59bd6de3-255d-4435-adf9-4035e0b1447d.PNG)
![Search screen](https://user-images.githubusercontent.com/19195181/168491848-2533a5a3-1acf-44e3-bf3c-1bb8312bef88.PNG)

rest api auth header details
64bit base code encode to be included for each api call. 
{"u":"duplo@gost.com", "p":"welcome@123","n":"duplo"}

## Getting Started development env
Follow the below steps to setup your development env 
install flutter [app](https://docs.flutter.dev/get-started/install/windows)
Any code editor I prefer [VS code](https://code.visualstudio.com/docs/setup/setup-overview) 
check out main branch 
When you run directly vs code with modify [launch.json](https://github.com/ramnkl16/ez_search_ui/blob/main/.vscode/launch.json) as per your target device. by default configured for chrome web running port 8080

Build app and push in windowns [app stores](https://docs.flutter.dev/deployment/windows) 
windows app available here [windows](https://github.com/ramnkl16/ez_search_ui/tree/main/app/windows) you can down load and run app



