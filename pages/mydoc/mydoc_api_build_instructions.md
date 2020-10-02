---
title: Api
keywords: Admin portal, Api
last_updated: April 10, 2020
tags: [api]
summary: "This document outlines how to build the Admin api using .NET core 3.1"
sidebar: mydoc_sidebar
permalink: mydoc_api_build_instructions.html
folder: mydoc
---

{% include important.html content="This Walkthrough guide explains how to build the Admin api using a command-line interface and/or Visual Studio Code. Some settings differ when using Visual Studio." %}

{% include important.html content="Security Flaw: Password=administrator below in Step 4 is publicly visible. It is the password for the projects MariaDB database, this will be changeable in the future, so that the project's seeding database cannot be so easily accessed." %}

## Requirements
- .NET Core 3.1 SDK or later. [How to install](https://docs.microsoft.com/en-us/dotnet/core/install/sdk?pivots=os-windows)
- MySql server (preferrably v8.0.19 or later) running with the database and tables already created

The .NET Core CLI is included with the .NET Core SDK. To check that you have it installed, open a terminal and run:
```bash
dotnet --info
#Output
.NET Core SDK (reflecting any global.json):
 Version:   3.1.200
...
```


## 1. Create a aspnet core web api
cd to your proyect directory and then run:

```bash
dotnet new webapi -o AdminApi
```


## 2. Install Packages
```bash
cd AdminApi

dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Pomelo.EntityFrameworkCore.MySql
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
```

{% include tip.html content="If you're using Visual Studio, we recommend the Package Manager Console tools instead." %}


## 3. Install tools
### Entity Framework Core
[Entity Framework (EF) Core](https://docs.microsoft.com/en-us/ef/core/) is a lightweight, extensible, open source and cross-platform version of the popular Entity Framework data access technology.

EF Core can serve as an object-relational mapper (O/RM), enabling developers to work with a database using .NET objects, and eliminating the need for most of the data-access code they usually need to write.

`dotnet ef` must be installed as a global or local tool. Most developers will install dotnet ef as a global tool with the following command:

```bash
dotnet tool install --global dotnet-ef
```

{% include note.html content="Object-relational mapping (ORM, O/RM, and O/R mapping tool) is a programming technique for converting data between incompatible type systems using object-oriented programming languages. This creates, in effect, a <i>virtual object database</i> that can be used from within the programming language." %}



### dotnet aspnet-codegenerator
`dotnet aspnet-codegenerator` -runs the ASP.NET Core scaffolding engine. `dotnet aspnet-codegenerator` is only required to scaffold from the command line, it's not needed to use scaffolding with Visual Studio.

```bash
dotnet tool install --global dotnet-aspnet-codegenerator
```

## 4. Reverse Engineering (Scaffolding) the database
We are going to use the `dotnet ef dbcontext scaffold` [command](https://docs.microsoft.com/en-us/ef/core/managing-schemas/scaffolding) to generate a Model and a database context from our existing database.


```bash
dotnet ef dbcontext scaffold "Server=localhost;Database=hairdressing_project_db;User=dev_admin;Password=administrator;TreatTinyAsBoolean=true;" "Pomelo.EntityFrameworkCore.MySql" -o GeneratedModels -d
```

This create the Models folder with all classes and the database context.

The DbContext is an important class in Entity Framework API. It is a bridge between your domain or entity classes and the database.
- The primary class that is responsible for interacting with data as objects DbContext.
- DbContext APIs simplify your application interaction with the database.

{% include tip.html content="To not expose the connection string configurations, we can use the Secret Manager tool to keep the database passwords hidden" %}

[Configuration and User Secrets](https://docs.microsoft.com/en-us/ef/core/managing-schemas/scaffolding#configuration-and-user-secrets)


## 5. Register the database context

Edit `AdminApi/Startup.cs` to register the database context

```c#
// ...

public void ConfigureServices(IServiceCollection services)
        {
            // Register DB Context
            services.AddDbContext<hair_project_dbContext>(options =>
            options
            .UseMySql(Configuration.GetConnectionString("HairDesignDB"), mySqlOptions =>
            mySqlOptions
            .ServerVersion(new ServerVersion(new Version(5, 7, 24), ServerType.MySql))
            ));
            
            services.AddControllers();
        }

// ...
```

Edit `AdminApi/appsettings.json` and add:
```json
"ConnectionStrings": {
    "HairDesignDB": "Server=localhost;Database=hair_project_db;User=dev_admin;Password=administrator;"
}
```


## 6. Scaffold Controllers

Using `dotnet aspnet-codegenerator` command (terminal or Visual Studio Code terminal)

```bash
dotnet aspnet-codegenerator controller -name UsersController -async -api -m Users -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name UserFeaturesController -async -api -m UserFeatures -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name SkinTonesController -async -api -m SkinTones -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name SkinToneLinksController -async -api -m SkinToneLinks -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name HairStylesController -async -api -m HairStyles -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name HairStyleLinksController -async -api -m HairStyleLinks -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name HairLengthsController -async -api -m HairLengths -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name HairLengthLinksController -async -api -m HairLengthLinks -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name FaceShapesController -async -api -m FaceShapes -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name FaceShapeLinksController -async -api -m FaceShapeLinks -dc hair_project_dbContext -outDir Controllers
dotnet aspnet-codegenerator controller -name ColoursController -async -api -m Colours -dc hair_project_dbContext -outDir Controllers
```

{% include note.html content="If using Visual Studio" %}

- Right-click the Controllers folder.
- Select Add > New Scaffolded Item.
- Select API Controller with actions, using Entity Framework, and then select Add.
- In the Add API Controller with actions, using Entity Framework dialog:
    - Select _ClassName_ (_AdminApi.Models_) in the Model class.git 
    - Select TodoContext (TodoApi.Models) in the Data context class.
    - Select Add.

{% include image.html file="/api/scaffold_controller_0.png" alt="Scaffold" caption="" %}
{% include image.html file="/api/scaffold_controller_1.png" alt="Scaffold" caption="" %}
{% include image.html file="/api/scaffold_controller_2.png" alt="Scaffold" caption="" %}

## 7. Start the server

In a terminal, from the `../AdminApi/` directory, execute:

```bash
dotnet run
```

