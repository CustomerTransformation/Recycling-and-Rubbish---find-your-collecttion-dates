USE [master]
GO

/****** Object:  Database [FStepMapInfo_prod]    Script Date: 30/03/2020 19:44:25 ******/
CREATE DATABASE [FStepMapInfo_prod]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FStepMapInfo', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\FStepMapInfo.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FStepMapInfo_log', FILENAME = N'E:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Logs\FStepMapInfo_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

ALTER DATABASE [FStepMapInfo_prod] SET COMPATIBILITY_LEVEL = 140
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FStepMapInfo_prod].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [FStepMapInfo_prod] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET ARITHABORT OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [FStepMapInfo_prod] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [FStepMapInfo_prod] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET  DISABLE_BROKER 
GO

ALTER DATABASE [FStepMapInfo_prod] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [FStepMapInfo_prod] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET RECOVERY SIMPLE 
GO

ALTER DATABASE [FStepMapInfo_prod] SET  MULTI_USER 
GO

ALTER DATABASE [FStepMapInfo_prod] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [FStepMapInfo_prod] SET DB_CHAINING OFF 
GO

ALTER DATABASE [FStepMapInfo_prod] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [FStepMapInfo_prod] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [FStepMapInfo_prod] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [FStepMapInfo_prod] SET QUERY_STORE = OFF
GO

ALTER DATABASE [FStepMapInfo_prod] SET  READ_WRITE 
GO

