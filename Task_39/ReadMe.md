# Базовые возможности mongodb 

### Установка СУБД MongoDB в Docker

Ранее уже запулил MongoDB:

![01](https://user-images.githubusercontent.com/95203401/166622617-95ac6910-ff57-4557-a060-788b0acc6a46.png)

Написал следующий yaml файл:

![02_02](https://user-images.githubusercontent.com/95203401/166622727-3231cf49-2ead-4383-b570-faddde15c573.png)

Через команду *docker-compose up* запустил контейнер с MongoDB
![03](https://user-images.githubusercontent.com/95203401/166622825-76e054ce-8ece-4c48-bf3d-444ca5f7f977.png)

далее подключился к MongoDB

![04_02](https://user-images.githubusercontent.com/95203401/166649489-c74f5b4c-6729-4d13-a3c2-945a6807469f.png)

### Загрузка данных

создал коллекцию "winequality"
закачал занные, взял отсюда https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/ 

![05_02](https://user-images.githubusercontent.com/95203401/166649936-88fb11be-fd1b-4f00-8a6e-7fe8941a2ad4.png)

Загрузил файлы "winequality-red.csv" и "winequality-white.csv"

![06_02](https://user-images.githubusercontent.com/95203401/166649984-0f8343b7-eb3b-4a5e-9067-4788b2ee941b.png)

### Запросы

Просто выборка с лимитом: 
**db.winequality.find().limit(5)**

![07_2](https://user-images.githubusercontent.com/95203401/166650088-38fbdf7e-d136-4c1a-8c76-ba99818c43b1.png)

Выборка вина, где крепость 10 градусов:
**db.winequality.find({"alcohol":10})**

![08](https://user-images.githubusercontent.com/95203401/166650119-3d3d5181-38de-4dcb-abab-f65e6271a4d3.png)

Выборка где pH больше 3:
**db.winequality.find({"pH":{$gt:3}})**

![8 5](https://user-images.githubusercontent.com/95203401/166650435-83d2efd4-4e15-4601-b411-c6501574117c.png)


Выборка ("фиксированная кислотность" > 13 and ("pH" > 3 or "качество" = 7)):

**db.winequality.find({"fixed acidity" : {$gte : 13},$or: [{"pH" :{$gt : 3}},{quality : 7}]})**

![09](https://user-images.githubusercontent.com/95203401/166650506-ae6a531f-0f31-4da0-92a0-66ec4f6050ee.png)

-----
### Обновление данных

обновление одной записи где ("pH" = 2.95 and "алкоголь" = 11.2), меняем поле "качество" = 8.2:

**db.winequality.updateOne({$and: [{"pH" : 2.95},{"alcohol" : 11.2}]}, {$set: {quality : 8.2}})**

![10](https://user-images.githubusercontent.com/95203401/166650802-7da10fe0-6a7f-4fa8-8467-8d79e8981636.png)

Обновление нескольких записей, где ("pH" = 2.9 и "алкоголь" > 11.2), меняем поле "качество" = 8.1:

**db.winequality.updateMany({$and: [{"pH" : 2.95},{"alcohol" : {$gt: 11.2}}]}, {$set: {quality : 8.1}})**

![11](https://user-images.githubusercontent.com/95203401/166650936-f0b16fee-81d9-4f02-88dc-e3253978761c.png)

### Задание повышенной сложности*

Выборка ("плотность" >= 0.9 and "остаточный сахар" < 1.9):

**db.winequality.find({$and : [{"density" : {$gte : 0.9}},{"residual sugar" : 1.9 }] })**

Результат без индекса:

***db.winequality.find({$and : [{"density" : {$gte : 0.9}},{"residual sugar" : 1.9 }] }).explain("executionStats")**

![12](https://user-images.githubusercontent.com/95203401/166651020-7930bd9c-5bd6-4483-bc03-c2d87c2cf2ad.png)

queryPlanner.winningPlan.stage = COLLSCAN, сканирование коллекции
executionStats.totalKeysExamined = 0 говорит о том, индекс не используется. 
executionStats.totalDocsExamined = 6497 значит что Mongo отсканировала 6497 документов

Создаю индекс:

**db.winequality.createIndex({"density" : 1, "residual" : 1})**

![13](https://user-images.githubusercontent.com/95203401/166651079-7cc0097b-2303-485a-95de-d1736ff80962.png)

Результат с индексом:

**db.winequality.find({$and : [{"density" : {$gte : 0.9}},{"residual sugar" : 1.9 }] }).explain("executionStats")**

![14](https://user-images.githubusercontent.com/95203401/166651115-411a7d55-deb3-4915-9bbd-f55297537cd3.png)

queryPlanner.winningPlan.inputStage.stage = IXSCAN указывает, что использовался индекс.
executionStats.totalKeysExamined = 6497, индекс используется

Я так понимаю для этого запроса выборка без индекса эффективнее?
