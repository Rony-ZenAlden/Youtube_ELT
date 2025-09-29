# **Youtube API - ELT**

## **Architecture** 

<p align="center">
  <img width="500" height="400" src="images/project_architecture.png">
</p>

## **Motivation** 

The aim of this project is to get familiar with data engineering tools such as Python, Docker & Airflow to produce an ELT data pipeline. To make the pipeline more robust, best practices of unit & data quality testing and continuous integration/continuous deployment (CI-CD) are also implemented.

## **Dataset** 

As a data source, the Youtube API is used. The data of this project is pulled from a popular channel - 'MrBeast'.
It is good to note that this project can be replicated for any other Youtube channel you would simply need to change the the Youtube Channel ID/ HandleS. 

## **Summary**

This ELT project uses Airflow as an orchestration tool, packaged inside docker containers. The steps that make up the project are as follows:

1. Data is **extracted** using the Youtube API with Python scripts 
2. The data is initially **loaded** into a `staging schema` which is a dockerized PostgreSQL database
3. From there, a python script is used for minor data **transformations** where the data is then loaded into the `core schema` (also a dockerized PostgreSQL database) 

The first (initial) API pull loads the data - this is the initial **full upload**. 
Successive pulls **upserts** the values for certain variables (columns). Once the core schema is populated and both unit and data quality tests have been implemented, the data is then ready for analysis. 

The following seven variables are extracted from the API: 
* *Video ID*, 
* *Video Title*, 
* *Upload Date*, 
* *Duration*,
* *Video Views*,
* *Likes Count*, 
* *Comments Count*

## **Tools & Technologies**

* *Containerization* - **Docker**, **Docker-Compose**
* *Orchestration* - **Airflow**
* *Data Storage* - **Postgres**
* *Languages* - **Python, SQL**
* *Testing* - **SODA**, **pytest**
* *CI-CD* - **Github Actions**
