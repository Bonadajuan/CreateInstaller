USE [master]
GO
/****** Object:  Database [LaundryRFID_WithScript]    Script Date: 7/12/2023 12:33:39 p. m. ******/
CREATE DATABASE [LaundryRFID_WithScript]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LaundryRFID_WithScript_20211221_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQL2017DEV\MSSQL\DATA\LaundryRFID_WithScript_20211221.mdf' , SIZE = 708608KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'LaundryRFID_WithScript_20211221_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQL2017DEV\MSSQL\DATA\LaundryRFID_WithScript_20211221.ldf' , SIZE = 284288KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [LaundryRFID_WithScript] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LaundryRFID_WithScript].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [LaundryRFID_WithScript] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET ARITHABORT OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET  DISABLE_BROKER 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET RECOVERY FULL 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET  MULTI_USER 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [LaundryRFID_WithScript] SET DB_CHAINING OFF 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [LaundryRFID_WithScript] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'LaundryRFID_WithScript', N'ON'
GO
ALTER DATABASE [LaundryRFID_WithScript] SET QUERY_STORE = OFF
GO
USE [LaundryRFID_WithScript]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [LaundryRFID_WithScript]
GO
/****** Object:  User [LaundryRFID]    Script Date: 7/12/2023 12:33:41 p. m. ******/
CREATE USER [LaundryRFID] FOR LOGIN [LaundryRFID] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [LaundryRFID]
GO
/****** Object:  UserDefinedFunction [dbo].[fBI_LocationParentSearch]    Script Date: 7/12/2023 12:33:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBI_LocationParentSearch](@eid int,@nivel int)
RETURNS varchar(100)
AS
BEGIN
    Declare @logid1 int = null;
    Declare @logid2 int = null;
    Declare @logid3 int = null;
    Declare @logid4 int = null;
    
    Declare @logname0 nvarchar(100)='';
    Declare @logname1 nvarchar(100)='';
    Declare @logname2 nvarchar(100)='';
    Declare @logname3 nvarchar(100)='';
    Declare @logname4 nvarchar(100)='';
    
   Declare @resultado1 nvarchar (100)=0;
    
    
      select @logid1 = isnull(parentid,-1),@logname0 = Name from Location where ID=@eid
      select @logid2 = isnull(parentid,-1),@logname1 = Name from Location where ID=@logid1
      select @logid3 = isnull(parentid,-1),@logname2 = Name from Location where ID=@logid2
      select @logid4 = isnull(parentid,-1),@logname3 = Name from Location where ID=@logid3

--Existe  y tiene nietos
if (@logid1 =-1 and @logid2 <>-1 and @logid3 <>-1 )
begin
if @nivel = 0 select @resultado1 =  @logname0
if @nivel = 1 select @resultado1 =  @logname1
if @nivel = 2 select @resultado1 =  @logname2
if @nivel = 3 select @resultado1 =  @logname3
end

--Existe  y tiene hijos
if (@logid1 <>-1 and @logid2  <>-1 and @logid3 = -1 )
begin
if @nivel = 0 select @resultado1 =  @logname2
if @nivel = 1 select @resultado1 =  @logname1
if @nivel = 2 select @resultado1 =  @logname0
if @nivel = 3 select @resultado1 =  ''
end

-----Existe  y tiene hijos
if (@logid1 <>-1  and @logid2  =-1  and @logid3  is null )
begin
if @nivel = 0 select @resultado1 =  @logname1
if @nivel = 1 select @resultado1 =  @logname0
if @nivel = 2 select @resultado1 =  ''
if @nivel = 3 select @resultado1 =  ''
end

-----Existe  y es padre
if (@logid1 =-1 and @logid2 is null and @logid3 is null )
begin
if @nivel = 0 select @resultado1 =  @logname0
if @nivel = 1 select @resultado1 =  ''
if @nivel = 2 select @resultado1 =  ''
if @nivel = 3 select @resultado1 =  ''
end

return @resultado1
END
GO
/****** Object:  UserDefinedFunction [dbo].[fBI_LocationTree]    Script Date: 7/12/2023 12:33:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fBI_LocationTree](@eid int)
RETURNS @t TABLE (ID int,Parent0 nvarchar(100),Parent1 nvarchar(100),Parent2 nvarchar(100),Parent3 nvarchar(100),Parent4 nvarchar(100))
AS
BEGIN
    Declare @logid1 int = null;
    Declare @logid2 int = null;
    Declare @logid3 int = null;
    Declare @logid4 int = null;
    Declare @logid5 int = null;
    
    Declare @logname0 nvarchar(100);
    Declare @logname1 nvarchar(100);
    Declare @logname2 nvarchar(100);
    Declare @logname3 nvarchar(100);
    Declare @logname4 nvarchar(100);
    
    
      select @logid1 = isnull(parentid,-1),@logname0 = Name from Location where ID=@eid
      select @logid2 = isnull(parentid,-1),@logname1 = Name from Location where ID=@logid1
      select @logid3 = isnull(parentid,-1),@logname2 = Name from Location where ID=@logid2
      select @logid4 = isnull(parentid,-1),@logname3 = Name from Location where ID=@logid3
      select @logid5 = isnull(parentid,-1),@logname4 = Name from Location where ID=@logid4

      If @logid1=-1 insert into @t values(@eid,@logname0,'','','','')
      If @logid2=-1 insert into @t values(@eid,@logname1,@logname0,'','','')
      If @logid3=-1 insert into @t values(@eid,@logname2,@logname1,@logname0,'','')
      If @logid4=-1 insert into @t values(@eid,@logname3,@logname2,@logname1,@logname0,'')
      
      --insert into @t Values(@logname0,'2','3','4','5')

RETURN

END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplit]    Script Date: 7/12/2023 12:33:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSplit](
    @sInputList VARCHAR(MAX) -- Lista de elementos delimitados por el separador indicado (par醡etro)
  , @sDelimiter VARCHAR(8000) = ',' -- Delimitador utilizado para separar los elementos
) RETURNS @List TABLE (item VARCHAR(8000))

BEGIN
DECLARE @sItem VARCHAR(8000)
WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
 BEGIN
 SELECT
  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),
  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))

 IF LEN(@sItem) > 0
  INSERT INTO @List SELECT @sItem
 END

IF LEN(@sInputList) > 0
 INSERT INTO @List SELECT @sInputList -- Put the last item in
RETURN
END -- function
GO
/****** Object:  Table [dbo].[Size]    Script Date: 7/12/2023 12:33:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Size](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Generic] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Size] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Brand]    Script Date: 7/12/2023 12:33:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brand](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ExternalCode] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Brand] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ColorArt]    Script Date: 7/12/2023 12:33:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ColorArt](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Generic] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.ColorArt] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GenerationType]    Script Date: 7/12/2023 12:33:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GenerationType](
	[Id] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GenerationType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 7/12/2023 12:33:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NameShort] [nvarchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Cuit] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Town] [nvarchar](max) NULL,
	[ZipCode] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[Remarks] [nvarchar](max) NULL,
	[RecepcionRfid] [bit] NOT NULL,
	[RecepcionManual] [bit] NOT NULL,
	[LocationInterna] [bit] NOT NULL,
	[ExternalCode] [nvarchar](max) NULL,
	[GeoreferenceLoc] [nvarchar](max) NULL,
	[ProvinceId] [int] NULL,
	[CostCenterId] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Laundry] [bit] NOT NULL,
	[SinRecepcion] [bit] NOT NULL,
	[Restriction] [bit] NOT NULL,
	[LocationExterna] [bit] NOT NULL,
	[AutoStartDelivery] [bit] NOT NULL,
	[DaysForDeliveryGuide] [int] NULL,
	[RequirePackagesReadOnRoadMap] [bit] NULL,
 CONSTRAINT [PK_dbo.Location] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Model]    Script Date: 7/12/2023 12:33:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Model](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](40) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[ItemsPerPackage] [int] NOT NULL,
	[PriceUnit] [real] NOT NULL,
	[ExternalCode] [nvarchar](10) NULL,
	[WetWeight] [real] NOT NULL,
	[DryWeight] [real] NOT NULL,
	[PrintingType] [nvarchar](100) NULL,
	[CategoryId] [int] NULL,
	[Excluded] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[TagsAsig] [bit] NOT NULL,
	[UsesSize] [bit] NOT NULL,
	[UsesColor] [bit] NOT NULL,
	[EnableItemQuantityControlPerPackage] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsPrimary] [bit] NOT NULL,
	[IsSecondary] [bit] NOT NULL,
	[WashCountLimit] [int] NULL,
	[WashCountAlert] [int] NULL,
 CONSTRAINT [PK_dbo.Model] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheet]    Script Date: 7/12/2023 12:33:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheet](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentOrderSheetId] [int] NULL,
	[OrderSheetStatusId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[Number] [varchar](20) NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[OrderSheetTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.OrderSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_OrderSheet] UNIQUE NONCLUSTERED 
(
	[Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheetItem]    Script Date: 7/12/2023 12:33:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheetItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderSheetId] [int] NOT NULL,
	[GenerationTypeId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[EnableItemQuantityControlPerPackage] [bit] NOT NULL,
	[ItemsPerPackage] [int] NOT NULL,
	[ReceivedQuantity] [int] NOT NULL,
	[DueQuantity] [int] NOT NULL,
	[OrderedQuantity] [int] NOT NULL,
	[PickedQuantity] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[SentQuantity] [int] NOT NULL,
	[ManualQuantity] [int] NULL,
	[AdvanceQuantity] [int] NULL,
 CONSTRAINT [PK_dbo.OrderSheetItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheetStatus]    Script Date: 7/12/2023 12:33:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheetStatus](
	[Id] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_OrderSheetStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Package]    Script Date: 7/12/2023 12:33:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Package](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ExternalCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.Package] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackageDetail]    Script Date: 7/12/2023 12:33:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ModelId] [int] NOT NULL,
	[PackageId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[DefaultForModel] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.PackageDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Article]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Article](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CodArt] [nvarchar](max) NULL,
	[ModelId] [int] NOT NULL,
	[ColorArtId] [int] NOT NULL,
	[SizeId] [int] NOT NULL,
	[BrandId] [int] NULL,
	[ExternalCode] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[Excluded] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Article] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuide]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuide](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GenerateDate] [datetime] NOT NULL,
	[LocationOriginId] [int] NOT NULL,
	[LocationDestinationId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ShippingNumber] [nvarchar](20) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[IsManual] [bit] NULL,
	[ShippingDate] [datetime] NULL,
	[ReceptionDate] [datetime] NULL,
	[ShippingGuideMovementTypeId] [int] NULL,
	[ShippingGuideStatusId] [int] NOT NULL,
	[OrderSheetId] [int] NULL,
	[IsUnrestricted] [bit] NULL,
	[IsPack] [bit] NULL,
 CONSTRAINT [PK_dbo.ShippingGuide] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ShippingNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideDetail]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShippingGuideId] [int] NOT NULL,
	[ItemId] [int] NULL,
	[ModelId] [int] NULL,
	[Quantity] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ArticleId] [int] NULL,
	[PackageDetailId] [int] NULL,
	[ShippingPackageId] [bigint] NULL,
 CONSTRAINT [PK_dbo.ShippingGuideDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[OrderSheetDetailView]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[OrderSheetDetailView]
AS
SELECT 
	O.Id AS [OrderSheet],
    OS.Id AS [StatusId],
	OS.Description AS [Status],
	O.CreationDate AS [OrderSheetDate],	
	L.Id AS [LocationId],
	L.Name AS [Location],
	G.Description AS [GenerationType],
	T.ArticleId, 
	T.ModelId, 
	P.Description AS [Package],
	P.Id AS [PackageId],
	PD.Quantity AS [PackageDetailQuantity],
	M.Code AS [Model],
	A.CodArt AS [Article],
	M.Description,
	C.Description AS [Color],
	S.Description AS [Size],
	B.Code AS Brand,
	ISNULL(T.ItemsPerPackage, M.ItemsPerPackage) AS [ItemsPerPackage],
	ISNULL(T.EnableItemQuantityControlPerPackage, M.EnableItemQuantityControlPerPackage) AS [EnableItemQuantityControlPerPackage],
	M.IsPrimary,
	M.IsSecondary,	
	M.TagsAsig AS [IsRFID],	
	T.ReceivedQuantity,
	T.DueQuantity,
	T.OrderedQuantity,
	T.PickedQuantity,
	T.SentQuantity,
	T.ShippingQuantity
FROM OrderSheet O
INNER JOIN (
	SELECT 
		T.OrderSheetId, 		
		T.ArticleId, 
		T.ModelId, 
		T.PackageDetailId,
		OSI.GenerationTypeId,
		OSI.EnableItemQuantityControlPerPackage,  
		OSI.ItemsPerPackage,
		OSI.ReceivedQuantity,
		OSI.DueQuantity,
		OSI.OrderedQuantity,
		OSI.PickedQuantity,
		OSI.SentQuantity,
		T.ShippingQuantity
	FROM 
	(
		SELECT SG.OrderSheetId, ArticleId, ModelId, SUM([Quantity]) AS ShippingQuantity, PackageDetailId
		FROM ShippingGuideDetail SGD
		INNER JOIN ShippingGuide SG ON SG.Id = SGD.ShippingGuideId
		WHERE SG.OrderSheetId IS NOT NULL
		GROUP BY SG.OrderSheetId, ArticleId, ModelId, PackageDetailId
	) T
	LEFT JOIN OrderSheetItem OSI ON OSI.OrderSheetId = T.OrderSheetId AND OSI.ModelId = T.ModelId AND OSI.ArticleId = T.ArticleId
	UNION ALL
	SELECT 
		OSI.OrderSheetId, 
		OSI.ArticleId, 
		OSI.ModelId, 
		NULL,
		OSI.GenerationTypeId,
		OSI.EnableItemQuantityControlPerPackage,  
		OSI.ItemsPerPackage,
		OSI.ReceivedQuantity,
		OSI.DueQuantity,
		OSI.OrderedQuantity,
		OSI.PickedQuantity,
		OSI.SentQuantity,
		NULL
	FROM OrderSheetItem OSI
	WHERE NOT EXISTS (
		SELECT 1
		FROM ShippingGuideDetail SGD
		INNER JOIN ShippingGuide SG ON SG.Id = SGD.ShippingGuideId
		WHERE OSI.OrderSheetId = OrderSheetId AND OSI.ModelId = ModelId AND OSI.ArticleId = ArticleId
	)
) T ON O.Id = T.OrderSheetId
INNER JOIN Location L ON O.LocationId = L.Id
INNER JOIN OrderSheetStatus OS ON O.OrderSheetStatusId = OS.Id
INNER JOIN Model M ON T.ModelId = M.Id
INNER JOIN Article A ON T.ArticleId = A.Id
LEFT JOIN ColorArt C ON A.ColorArtId = C.Id AND C.Generic = 0
LEFT JOIN Size S ON A.SizeId = S.Id AND S.Generic = 0
LEFT JOIN Brand B ON A.BrandId = B.Id
LEFT JOIN GenerationType G ON T.GenerationTypeId = G.Id
LEFT JOIN PackageDetail PD1 ON T.PackageDetailId = PD1.Id
LEFT JOIN Package P ON PD1.PackageId = P.Id
LEFT JOIN PackageDetail PD ON PD.PackageId = P.Id AND M.Id = PD.ModelId
GO
/****** Object:  Table [dbo].[ReceptionGuide]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionGuide](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GenerateDate] [datetime] NOT NULL,
	[ReceptionNumber] [nvarchar](20) NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Remarks] [nvarchar](max) NULL,
	[IsManual] [bit] NULL,
	[LocationDestinationId] [int] NOT NULL,
	[LocationOriginId] [int] NULL,
	[OrderSheetId] [int] NULL,
 CONSTRAINT [PK_dbo.ReceptionGuide] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UQ__Receptio__7CAB7985351D6B45] UNIQUE NONCLUSTERED 
(
	[ReceptionNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[OrderSheetView]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[OrderSheetView]
AS
SELECT
	O.Id AS [OrderSheet],
    OS.Id AS [StatusId],
	OS.Description AS [Status],
	O.CreationDate AS [OrderSheetDate],
	L.Id AS [LocationId],
	L.Name AS [Location],
	STUFF((SELECT ', ' + Number FROM OrderSheet WHERE ParentOrderSheetId = O.Id FOR XML PATH('')), 1, 2, '') AS [Related],
	STUFF((SELECT ', ' + ReceptionNumber FROM ReceptionGuide WHERE OrderSheetId = O.Id FOR XML PATH('')), 1, 2, '') AS [ReceptionGuides],
	STUFF((SELECT ', ' + ShippingNumber FROM ShippingGuide WHERE OrderSheetId = O.Id FOR XML PATH('')), 1, 2, '') AS [ShippingGuides]
FROM OrderSheet O
INNER JOIN OrderSheetStatus OS ON O.OrderSheetStatusId = OS.Id
INNER JOIN Location L ON O.LocationId = L.Id
GO
/****** Object:  View [dbo].[DailyDebtView]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[DailyDebtView]
AS
SELECT 
	O.Id AS [OrderSheet],
	O.CreationDate AS [OrderSheetDate],	
	L.Id AS [LocationId],
	L.Name AS [Location],
	SUM(ISNULL(T.OrderedQuantity, 0)-ISNULL(T.ShippingQuantity, 0)) AS Diff
FROM OrderSheet O
INNER JOIN (
	SELECT 
		T.OrderSheetId, 		
		T.ArticleId, 
		T.ModelId, 
		T.PackageDetailId,
		OSI.GenerationTypeId,
		OSI.EnableItemQuantityControlPerPackage,  
		OSI.ItemsPerPackage,
		OSI.ReceivedQuantity,
		OSI.DueQuantity,
		OSI.OrderedQuantity,
		OSI.PickedQuantity,
		OSI.SentQuantity,
		T.ShippingQuantity
	FROM 
	(
		SELECT SG.OrderSheetId, ArticleId, ModelId, SUM([Quantity]) AS ShippingQuantity, PackageDetailId
		FROM ShippingGuideDetail SGD
		INNER JOIN ShippingGuide SG ON SG.Id = SGD.ShippingGuideId
		WHERE SG.OrderSheetId IS NOT NULL
		GROUP BY SG.OrderSheetId, ArticleId, ModelId, PackageDetailId
	) T
	LEFT JOIN OrderSheetItem OSI ON OSI.OrderSheetId = T.OrderSheetId AND OSI.ModelId = T.ModelId AND OSI.ArticleId = T.ArticleId
	UNION ALL
	SELECT 
		OSI.OrderSheetId, 
		OSI.ArticleId, 
		OSI.ModelId, 
		NULL,
		OSI.GenerationTypeId,
		OSI.EnableItemQuantityControlPerPackage,  
		OSI.ItemsPerPackage,
		OSI.ReceivedQuantity,
		OSI.DueQuantity,
		OSI.OrderedQuantity,
		OSI.PickedQuantity,
		OSI.SentQuantity,
		NULL
	FROM OrderSheetItem OSI
	WHERE NOT EXISTS (
		SELECT 1
		FROM ShippingGuideDetail SGD
		INNER JOIN ShippingGuide SG ON SG.Id = SGD.ShippingGuideId
		WHERE OSI.OrderSheetId = OrderSheetId AND OSI.ModelId = ModelId AND OSI.ArticleId = ArticleId
	)
) T ON O.Id = T.OrderSheetId
INNER JOIN Location L ON O.LocationId = L.Id
INNER JOIN OrderSheetStatus OS ON O.OrderSheetStatusId = OS.Id
INNER JOIN OrderSheet ORD ON ORD.Id = T.OrderSheetId
INNER JOIN Model M ON T.ModelId = M.Id
INNER JOIN Article A ON T.ArticleId = A.Id
LEFT JOIN ColorArt C ON A.ColorArtId = C.Id AND C.Generic = 0
LEFT JOIN Size S ON A.SizeId = S.Id AND S.Generic = 0
LEFT JOIN Brand B ON A.BrandId = B.Id
LEFT JOIN GenerationType G ON T.GenerationTypeId = G.Id
WHERE (ISNULL(T.OrderedQuantity, 0)-ISNULL(T.ShippingQuantity, 0)) > 0
GROUP BY O.CreationDate,L.Id,L.Name,O.Id
GO
/****** Object:  View [dbo].[DailyDebtDetailView]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[DailyDebtDetailView]
AS
SELECT 
	O.Id AS [OrderSheet],
    OS.Id AS [StatusId],
	OS.Description AS [Status],
	CAST(O.CreationDate AS date) AS [OrderSheetDate],	
	L.Id AS [LocationId],
	L.Name AS [Location],
	G.Description AS [GenerationType],
	T.ArticleId, 
	T.ModelId, 
	M.Code AS [Model],
	A.CodArt AS [Article],
	M.Description,
	C.Description AS [Color],
	S.Description AS [Size],
	B.Code AS Brand,
	ISNULL(T.ItemsPerPackage, M.ItemsPerPackage) AS [ItemsPerPackage],
	ISNULL(T.EnableItemQuantityControlPerPackage, M.EnableItemQuantityControlPerPackage) AS [EnableItemQuantityControlPerPackage],
	M.IsPrimary,
	M.IsSecondary,	
	M.TagsAsig AS [IsRFID],	
	T.ReceivedQuantity,
	T.DueQuantity,
	T.OrderedQuantity,
	T.PickedQuantity,
	T.SentQuantity,
	T.ShippingQuantity,
	ISNULL(T.OrderedQuantity, 0)-ISNULL(T.ShippingQuantity, 0) AS Diff
FROM OrderSheet O
INNER JOIN (
	SELECT 
		T.OrderSheetId, 		
		T.ArticleId, 
		T.ModelId, 
		T.PackageDetailId,
		OSI.GenerationTypeId,
		OSI.EnableItemQuantityControlPerPackage,  
		OSI.ItemsPerPackage,
		OSI.ReceivedQuantity,
		OSI.DueQuantity,
		OSI.OrderedQuantity,
		OSI.PickedQuantity,
		OSI.SentQuantity,
		T.ShippingQuantity
	FROM 
	(
		SELECT SG.OrderSheetId, ArticleId, ModelId, SUM([Quantity]) AS ShippingQuantity, PackageDetailId
		FROM ShippingGuideDetail SGD
		INNER JOIN ShippingGuide SG ON SG.Id = SGD.ShippingGuideId
		WHERE SG.OrderSheetId IS NOT NULL
		GROUP BY SG.OrderSheetId, ArticleId, ModelId, PackageDetailId
	) T
	LEFT JOIN OrderSheetItem OSI ON OSI.OrderSheetId = T.OrderSheetId AND OSI.ModelId = T.ModelId AND OSI.ArticleId = T.ArticleId
	UNION ALL
	SELECT 
		OSI.OrderSheetId, 
		OSI.ArticleId, 
		OSI.ModelId, 
		NULL,
		OSI.GenerationTypeId,
		OSI.EnableItemQuantityControlPerPackage,  
		OSI.ItemsPerPackage,
		OSI.ReceivedQuantity,
		OSI.DueQuantity,
		OSI.OrderedQuantity,
		OSI.PickedQuantity,
		OSI.SentQuantity,
		NULL
	FROM OrderSheetItem OSI
	WHERE NOT EXISTS (
		SELECT 1
		FROM ShippingGuideDetail SGD
		INNER JOIN ShippingGuide SG ON SG.Id = SGD.ShippingGuideId
		WHERE OSI.OrderSheetId = OrderSheetId AND OSI.ModelId = ModelId AND OSI.ArticleId = ArticleId
	)
) T ON O.Id = T.OrderSheetId
INNER JOIN Location L ON O.LocationId = L.Id
INNER JOIN OrderSheetStatus OS ON O.OrderSheetStatusId = OS.Id
INNER JOIN OrderSheet ORD ON ORD.Id = T.OrderSheetId
INNER JOIN Model M ON T.ModelId = M.Id
INNER JOIN Article A ON T.ArticleId = A.Id
LEFT JOIN ColorArt C ON A.ColorArtId = C.Id AND C.Generic = 0
LEFT JOIN Size S ON A.SizeId = S.Id AND S.Generic = 0
LEFT JOIN Brand B ON A.BrandId = B.Id
LEFT JOIN GenerationType G ON T.GenerationTypeId = G.Id
WHERE (ISNULL(T.OrderedQuantity, 0)-ISNULL(T.ShippingQuantity, 0)) > 0
GO
/****** Object:  Table [dbo].[Item]    Script Date: 7/12/2023 12:33:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Epc] [nvarchar](30) NULL,
	[LastDateMove] [datetime] NOT NULL,
	[ExternalCode] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[LocationId] [int] NOT NULL,
	[StateTagsId] [int] NOT NULL,
	[SupplierId] [int] NULL,
	[ArticleId] [int] NOT NULL,
	[Excluded] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedDate] [datetime] NULL,
	[TotalWashCount] [int] NULL,
	[CurrentWashCount] [int] NULL,
	[LastWashDate] [datetime] NULL,
	[AssignDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Item] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_Item] UNIQUE NONCLUSTERED 
(
	[Epc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssetsTraceability]    Script Date: 7/12/2023 12:33:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetsTraceability](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[StateTagId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[AssetScrapCauseId] [int] NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[AssetMovementTypeId] [int] NOT NULL,
	[ArticleId] [int] NULL,
 CONSTRAINT [PK_dbo.AssetsTraceability] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ReassignedItemView]    Script Date: 7/12/2023 12:33:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ReassignedItemView] AS
SELECT DISTINCT 
	I.Id AS ItemId,
	I.ArticleId,
	I.Epc, 
	ATO.CreationDate, 
	AO.Id AS OriginalArticleId, 
	AO.ModelId AS OriginalModelId, 
	AO.BrandId AS OriginalBrandId,
	AO.CodArt AS OriginalCodArt, 
	MO.Description AS OriginalDescription, 
	AN.Id AS NewArticleId,
	AN.ModelId AS NewModelId, 
	AN.BrandId AS NewBrandId,
	AN.CodArt AS NewCodArt, 
	MN.Description AS NewDescription, 
	I.LastDateMove
FROM AssetsTraceability ATO
INNER JOIN AssetsTraceability ATN ON ATO.ItemId = ATN.ItemId 
					AND ATO.AssetMovementTypeId = 2 
					AND ATN.AssetMovementTypeId = 1 
					AND DATEDIFF(MINUTE, ATO.CreationDate, ATN.CreationDate) BETWEEN 0 AND 5
INNER JOIN Article AO ON AO.Id = ATO.ArticleId
INNER JOIN Model MO ON AO.ModelId = MO.Id
INNER JOIN Article AN ON AN.Id = ATN.ArticleId
INNER JOIN Model MN ON AN.ModelId = MN.Id
INNER JOIN Item I ON ATO.ItemId = I.Id
GO
/****** Object:  Table [dbo].[ShippingGuideStatus]    Script Date: 7/12/2023 12:33:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideStatus](
	[Id] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ShippingGuideStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 7/12/2023 12:33:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ExternalCode] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsComposition] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[BI_ShippingGuideDetailLaundryView]    Script Date: 7/12/2023 12:33:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[BI_ShippingGuideDetailLaundryView]
AS
SELECT  
	sgd.CreationDate as DateFull,
	CONVERT(DATE, sgd.CreationDate) as Date,
	CONVERT(char(8), sgd.CreationDate, 108) as Time,
	DATEPART([hour], sgd.CreationDate) as Hour,
	sg.ShippingNumber as ShippingGuide, 
	sgs.Description as ShippingGuideStatus,
	sg.OrderSheetId as OrderSheet,
	loco.Name as LocationOrigin,
	locd.Name as LocationDestination,
	cat.Description as Category,
	mo.Description as Model,
	art.CodArt as Article,
	bra.Description as Brand,
	siz.Description as Size,
	cart.Description as Color,
	sgd.Quantity as Quantity
	FROM ShippingGuideDetail sgd
	INNER JOIN ShippingGuide sg on sg.id=sgd.ShippingGuideId
	INNER JOIN ShippingGuideStatus sgs on sg.ShippingGuideStatusId = sgs.Id
	INNER JOIN Model mo on mo.Id = sgd.ModelId
	INNER JOIN Category cat on cat.Id = mo.CategoryId
	INNER JOIN Article art on sgd.ArticleId = art.Id
	INNER JOIN Brand bra on art.BrandId = bra.Id
	INNER JOIN Size siz on art.SizeId = siz.Id
	INNER JOIN ColorArt cart on art.ColorArtId = cart.Id
	INNER JOIN Location as loco on sg.LocationOriginId = loco.Id
	INNER JOIN Location as locd on sg.LocationDestinationId = locd.Id
	WHERE sg.LocationOriginId =2
	GROUP BY sg.ShippingNumber,
	sgd.CreationDate,sg.ShippingGuideStatusId,
	sgs.Description,
	cat.Description,mo.Description,art.CodArt,
	bra.Description, siz.Description,
	cart.Description,sgd.Quantity,sg.OrderSheetId,loco.Name,locd.Name
GO
/****** Object:  Table [dbo].[StateTags]    Script Date: 7/12/2023 12:33:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateTags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.StateTags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[BI_EpcByShippingGuide]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[BI_EpcByShippingGuide]
AS
SELECT   
	ite.Epc, stt.Name as StateTags,
	cat.Description as Category, mdl.Description as Model,
	bra.Description as Brand, siz.Description as Size,
	cart.Description as Color, 
	COUNT(1) as Quantity
	FROM ShippingGuideDetail sgd
	INNER JOIN ShippingGuide sg ON sgd.ShippingGuideId = sg.id
	INNER JOIN Item ite ON sgd.ItemId = ite.Id 
	INNER JOIN StateTags stt ON ite.StateTagsId = stt.Id
	INNER JOIN Article art ON ite.ArticleId = art.Id
	INNER JOIN Model mdl ON art.ModelId = mdl.Id
	INNER JOIN Category cat ON mdl.CategoryId = cat.Id
	INNER JOIN Brand bra ON art.BrandId = bra.Id
	INNER JOIN Size siz ON art.SizeId = siz.Id
	INNER JOIN ColorArt cart ON art.ColorArtId = cart.Id
	WHERE sg.LocationOriginId =2
	GROUP BY ite.Epc,stt.Name,
	cat.Description, mdl.Description,bra.Description,
	siz.Description,cart.Description
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[ContactName] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[ZipCode] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Cuit] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[ExternalCode] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Supplier] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[BI_EpcByItem]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[BI_EpcByItem]
AS
SELECT 
	ite.Epc, 
	loc.Name as Location, stt.Name as StateTags,
	ite.CurrentWashCount, ite.TotalWashCount,
	sup.Name as Supplier,
	cat.Description as Category, mdl.Description as Model,
	bra.Description as Brand, siz.Description as Size,
	cart.Description as Color
	FROM item ite
	INNER JOIN Location loc ON ite.LocationId = loc.id
	INNER JOIN StateTags stt ON ite.StateTagsId = stt.Id
	INNER JOIN Supplier sup ON ite.SupplierId = sup.Id
	INNER JOIN Article art ON ite.ArticleId = art.Id
	INNER JOIN Model mdl ON art.ModelId = mdl.Id
	INNER JOIN Category cat ON mdl.CategoryId = cat.Id
	INNER JOIN Brand bra ON art.BrandId = bra.Id
	INNER JOIN Size siz ON art.SizeId = siz.Id
	INNER JOIN ColorArt cart ON art.ColorArtId = cart.Id
GO
/****** Object:  View [dbo].[BI_ShippingGuideDetailInternView]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[BI_ShippingGuideDetailInternView]
AS
SELECT  
	sgd.CreationDate as DateFull,
	CONVERT(DATE, sgd.CreationDate) as Date,
	CONVERT(char(8), sgd.CreationDate, 108) as Time,
	DATEPART([hour], sgd.CreationDate) as Hour,
	sg.ShippingNumber as ShippingGuide, 
	sgs.Description as ShippingGuideStatus,
	sg.OrderSheetId as OrderSheet,
	loco.Name as LocationOrigin,
	locd.Name as LocationDestination,
	cat.Description as Category,
	mo.Description as Model,
	art.CodArt as Article,
	bra.Description as Brand,
	siz.Description as Size,
	cart.Description as Color,
	sgd.Quantity as Quantity
	FROM ShippingGuideDetail sgd
	INNER JOIN ShippingGuide sg on sg.id=sgd.ShippingGuideId
	INNER JOIN ShippingGuideStatus sgs on sg.ShippingGuideStatusId = sgs.Id
	INNER JOIN Model mo on mo.Id = sgd.ModelId
	INNER JOIN Category cat on cat.Id = mo.CategoryId
	INNER JOIN Article art on sgd.ArticleId = art.Id
	INNER JOIN Brand bra on art.BrandId = bra.Id
	INNER JOIN Size siz on art.SizeId = siz.Id
	INNER JOIN ColorArt cart on art.ColorArtId = cart.Id
	INNER JOIN Location as loco on sg.LocationOriginId = loco.Id
	INNER JOIN Location as locd on sg.LocationDestinationId = locd.Id
	WHERE (loco.LocationInterna = 1 or locd.LocationInterna = 1)
	GROUP BY sg.ShippingNumber,
	sgd.CreationDate,sg.ShippingGuideStatusId,
	sgs.Description,
	cat.Description,mo.Description,art.CodArt,
	bra.Description, siz.Description,
	cart.Description,sgd.Quantity,sg.OrderSheetId,loco.Name,locd.Name
GO
/****** Object:  Table [dbo].[AssetsMovementsType]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetsMovementsType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.AssetsMovementsType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[BI_Traceability]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[BI_Traceability]
AS
SELECT 
	at.CreationDate as DateFull,
	CONVERT(DATE, at.CreationDate) as Date,
	CONVERT(char(8), at.CreationDate, 108) as Time,
	DATEPART([hour], at.CreationDate) as Hour,
	ite.Epc,
	loc.Name as Location, stt.Name as StateTags,
	amt.Description as AssetsMovementsType,
	art.CodArt as Article,
	cat.Description as Category,
	mo.Description as Model,
	bra.Description as Brand,
	siz.Description as Size,
	cart.Description as Color
	FROM AssetsTraceability at
	INNER JOIN item ite on ite.Id = at.ItemId
	INNER JOIN Location loc on loc.Id = ite.LocationId
	INNER JOIN StateTags stt on stt.Id = at.StateTagId
	INNER JOIN AssetsMovementsType amt on amt.Id = at.AssetMovementTypeId
	INNER JOIN Article art on art.Id = at.ArticleId
	INNER JOIN Model mo on mo.Id = art.ModelId
	INNER JOIN Category cat on cat.Id = mo.CategoryId
	INNER JOIN Brand bra on art.BrandId = bra.Id
	INNER JOIN Size siz on art.SizeId = siz.Id
	INNER JOIN ColorArt cart on art.ColorArtId = cart.Id
GO
/****** Object:  Table [dbo].[AssetsMovementsHeader]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetsMovementsHeader](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceLocationId] [int] NOT NULL,
	[DestinationLocationId] [int] NOT NULL,
	[PermissionRequired] [bit] NOT NULL,
	[AssetMovementTypeId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ShippingGuideId] [int] NULL,
	[ReceptionGuideId] [int] NULL,
	[AuditGuideId] [int] NULL,
	[DeliveryGuideId] [int] NULL,
 CONSTRAINT [PK_dbo.AssetsMovementsHeader] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssetsMovementsItems]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetsMovementsItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AssetsMovementHeaderId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModelId] [int] NULL,
	[ArticleId] [int] NULL,
	[PackageQuantity] [int] NULL,
 CONSTRAINT [PK_dbo.AssetsMovementsItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_AssetsMovementsItems] UNIQUE NONCLUSTERED 
(
	[AssetsMovementHeaderId] ASC,
	[ArticleId] ASC,
	[ModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssetsMovementsItemsDetail]    Script Date: 7/12/2023 12:33:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetsMovementsItemsDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AssetsMovementsItemId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ArticleId] [int] NULL,
 CONSTRAINT [PK_dbo.AssetsMovementsItemsDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_AssetsMovementsItemsDetail] UNIQUE NONCLUSTERED 
(
	[AssetsMovementsItemId] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AssetsScrapCause]    Script Date: 7/12/2023 12:33:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssetsScrapCause](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.AssetsScrapCause] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditGuide]    Script Date: 7/12/2023 12:33:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditGuide](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GenerateDate] [datetime] NOT NULL,
	[LocationId] [int] NOT NULL,
	[Number] [nvarchar](20) NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Remarks] [nvarchar](max) NULL,
	[IsManual] [bit] NULL,
	[IsUHF] [bit] NULL,
 CONSTRAINT [PK_dbo.AuditGuide] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditGuideDetail]    Script Date: 7/12/2023 12:33:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditGuideDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AuditGuideId] [int] NOT NULL,
	[ItemId] [int] NULL,
	[ArticleId] [int] NULL,
	[ModelId] [int] NULL,
	[Quantity] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[PackId] [int] NULL,
 CONSTRAINT [PK_dbo.AuditGuideDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_AuditGuideDetail] UNIQUE NONCLUSTERED 
(
	[AuditGuideId] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditGuideError]    Script Date: 7/12/2023 12:33:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditGuideError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AuditGuideId] [int] NOT NULL,
	[IncorrectLocation] [int] NOT NULL,
	[Lost] [int] NOT NULL,
	[InTransit] [int] NOT NULL,
	[Eliminated] [int] NOT NULL,
	[PendingSend] [int] NOT NULL,
	[PendingRead] [int] NOT NULL,
	[Unassigned] [int] NOT NULL,
 CONSTRAINT [PK_AuditGuideError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_AuditGuideError] UNIQUE NONCLUSTERED 
(
	[AuditGuideId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditGuideErrorDetail]    Script Date: 7/12/2023 12:33:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditGuideErrorDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[AuditGuideTypeErrorId] [int] NOT NULL,
	[AuditGuideErrorId] [int] NOT NULL,
 CONSTRAINT [PK_AuditGuideErrorDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_AuditGuideErrorDetail] UNIQUE NONCLUSTERED 
(
	[AuditGuideErrorId] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditGuideRow]    Script Date: 7/12/2023 12:33:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditGuideRow](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Filename] [varchar](255) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[processDate] [datetime] NULL,
	[ImportDate] [datetime] NULL,
	[RowNumber] [int] NOT NULL,
	[Number] [nvarchar](20) NOT NULL,
	[GenerateDate] [datetime] NOT NULL,
	[LocationShortName] [nvarchar](20) NOT NULL,
	[Epc] [nvarchar](30) NOT NULL,
	[AuditGuideTypeError] [varchar](50) NULL,
	[LocationId] [int] NULL,
	[ItemId] [int] NULL,
	[AuditGuideTypeErrorId] [int] NULL,
	[AuditExists] [bit] NULL,
	[LocationExists] [bit] NULL,
	[ItemExists] [bit] NULL,
	[AuditGuideTypeErrorExists] [bit] NULL,
 CONSTRAINT [PK_AuditGuideRow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_AuditGuideRow] UNIQUE NONCLUSTERED 
(
	[Filename] ASC,
	[RowNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditGuideTypeError]    Script Date: 7/12/2023 12:33:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditGuideTypeError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AuditGuideTypeError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuthorizationLog]    Script Date: 7/12/2023 12:33:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthorizationLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SysFunctionId] [int] NOT NULL,
	[ShippingGuideId] [int] NULL,
	[ReceptionGuideId] [int] NULL,
	[OrderSheetId] [int] NULL,
	[DeliveryGuideId] [int] NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.AuthorizationLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AutomaticReception]    Script Date: 7/12/2023 12:33:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutomaticReception](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[LocationOriginId] [int] NOT NULL,
	[LocationDestinationId] [int] NOT NULL,
	[ReceptionGuideId] [int] NULL,
	[Deleted] [bit] NULL,
	[UserAccountId] [int] NULL,
 CONSTRAINT [PK_AutomaticReception] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AutomaticReceptionDetail]    Script Date: 7/12/2023 12:33:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutomaticReceptionDetail](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[AutomaticReceptionId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ItemId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[Washed] [bit] NULL,
	[WashedDate] [datetime] NULL,
 CONSTRAINT [PK_AutomaticReceptionDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Billing]    Script Date: 7/12/2023 12:33:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Billing](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[ItemCount] [int] NOT NULL,
	[CheckpointCount] [int] NOT NULL,
	[MobileCount] [int] NOT NULL,
	[GenerationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Billing] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BrandLocation]    Script Date: 7/12/2023 12:33:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BrandLocation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [int] NOT NULL,
	[BrandId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.BrandLocation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CheckPoint]    Script Date: 7/12/2023 12:33:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckPoint](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](max) NULL,
	[Name] [nvarchar](max) NULL,
	[IpService] [nvarchar](max) NULL,
	[IpClient] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[CheckpointTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.CheckPoint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CheckpointGroup]    Script Date: 7/12/2023 12:33:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckpointGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[LocationId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Version] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_CheckpointGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CheckpointInGroup]    Script Date: 7/12/2023 12:33:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckpointInGroup](
	[CheckpointId] [int] NOT NULL,
	[CheckpointGroupId] [int] NOT NULL,
 CONSTRAINT [PK_CheckpointInGroup] PRIMARY KEY CLUSTERED 
(
	[CheckpointId] ASC,
	[CheckpointGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CheckpointType]    Script Date: 7/12/2023 12:33:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckpointType](
	[Id] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CheckpointType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Container]    Script Date: 7/12/2023 12:33:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Container](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[ExternalCode] [nvarchar](50) NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedUserAccountId] [int] NULL,
	[Version] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_Container] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerExit]    Script Date: 7/12/2023 12:33:50 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerExit](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[CheckpointId] [int] NOT NULL,
	[DestinationLocationId] [int] NULL,
	[ContainerId] [int] NOT NULL,
	[IsAuthorized] [bit] NOT NULL,
 CONSTRAINT [PK_ContainerExit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerLocation]    Script Date: 7/12/2023 12:33:50 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerLocation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[ContainerId] [int] NOT NULL,
	[LocationOriginId] [int] NOT NULL,
	[LocationDestinationId] [int] NULL,
	[HasError] [bit] NULL,
 CONSTRAINT [PK_ContainerLocation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerLocationItem]    Script Date: 7/12/2023 12:33:50 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerLocationItem](
	[ContainerLocationId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
 CONSTRAINT [PK_ContainerLocationItem] PRIMARY KEY CLUSTERED 
(
	[ContainerLocationId] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerLocationItemError]    Script Date: 7/12/2023 12:33:50 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerLocationItemError](
	[ContainerLocationId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
 CONSTRAINT [PK_ContainerLocationItemError] PRIMARY KEY CLUSTERED 
(
	[ContainerLocationId] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CostCenter]    Script Date: 7/12/2023 12:33:50 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CostCenter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ExternalCode] [nvarchar](max) NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.CostCenter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryGuide]    Script Date: 7/12/2023 12:33:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryGuide](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryDate] [datetime] NOT NULL,
	[LocationId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[Number] [varchar](20) NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Remarks] [varchar](max) NULL,
 CONSTRAINT [PK_dbo.DeliveryGuide] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryGuideDetail]    Script Date: 7/12/2023 12:33:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryGuideDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeliveryGuideId] [int] NOT NULL,
	[ItemId] [int] NULL,
	[ArticleId] [int] NULL,
	[ModelId] [int] NULL,
	[Quantity] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.DeliveryGuideDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 7/12/2023 12:33:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Department] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentType]    Script Date: 7/12/2023 12:33:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_DocumentType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 7/12/2023 12:33:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FileNumber] [varchar](10) NULL,
	[FirstName] [varchar](100) NOT NULL,
	[LastName] [varchar](100) NOT NULL,
	[DocumentTypeId] [int] NOT NULL,
	[DocumentNumber] [varchar](10) NOT NULL,
	[Ceco] [varchar](50) NULL,
	[RegistrationStatus] [char](1) NULL,
	[BirthDate] [datetime] NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[PositionId] [int] NULL,
	[SectorId] [int] NULL,
 CONSTRAINT [PK_dbo.Employee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UI_Employee] UNIQUE NONCLUSTERED 
(
	[DocumentTypeId] ASC,
	[DocumentNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeCheckpoinRelease]    Script Date: 7/12/2023 12:33:52 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCheckpoinRelease](
	[CheckPointRelease_Id] [int] NOT NULL,
	[EmployeeRelease_Id] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeCheckpoinRelease] PRIMARY KEY CLUSTERED 
(
	[CheckPointRelease_Id] ASC,
	[EmployeeRelease_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeFingerprint]    Script Date: 7/12/2023 12:33:52 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeFingerprint](
	[EmployeeId] [int] NOT NULL,
	[FingerprintId] [int] NOT NULL,
 CONSTRAINT [PK_EmployeeFingerprint] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC,
	[FingerprintId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventLog]    Script Date: 7/12/2023 12:33:52 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[EventLogTypeId] [int] NOT NULL,
	[HostAddress] [varchar](45) NULL,
	[HostName] [varchar](50) NULL,
	[Controller] [varchar](30) NULL,
	[Action] [varchar](50) NULL,
	[Url] [varchar](max) NULL,
	[Message] [varchar](max) NULL,
	[Exception] [varchar](50) NULL,
	[StackTrace] [varchar](max) NULL,
	[UserAccountId] [int] NULL,
 CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EventLogType]    Script Date: 7/12/2023 12:33:52 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLogType](
	[Id] [int] NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Description] [varchar](30) NOT NULL,
 CONSTRAINT [PK_EventLogType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Fingerprint]    Script Date: 7/12/2023 12:33:52 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fingerprint](
	[Id] [int] NOT NULL,
	[Template] [varchar](max) NOT NULL,
	[Template10] [varchar](max) NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Fingerprint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocationResponsible]    Script Date: 7/12/2023 12:33:52 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationResponsible](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [int] NOT NULL,
	[ResponsibleId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.LocationResponsible] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Monitor]    Script Date: 7/12/2023 12:33:53 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Monitor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[ItemId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[StateTagsId] [int] NOT NULL,
	[CheckpointId] [int] NOT NULL,
	[Autorized] [bit] NOT NULL,
	[EmployeeId] [int] NULL,
 CONSTRAINT [PK_Monitor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheetAdvance]    Script Date: 7/12/2023 12:33:53 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheetAdvance](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[OrderSheetAdvanceStatusId] [int] NOT NULL,
	[QuantityRequested] [int] NOT NULL,
	[QuantityAccepted] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Version] [int] NOT NULL,
	[OrderSheetRequestedId] [int] NULL,
	[OrderSheetAcceptedId] [int] NULL,
 CONSTRAINT [PK_OrderSheetAdvance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheetAdvanceStatus]    Script Date: 7/12/2023 12:33:53 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheetAdvanceStatus](
	[Id] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_OrderSheetAdvanceStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheetDetail]    Script Date: 7/12/2023 12:33:53 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheetDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderSheetId] [int] NOT NULL,
	[ModelId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_OrderSheetDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheetSuspension]    Script Date: 7/12/2023 12:33:53 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheetSuspension](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [int] NOT NULL,
	[LimitDate] [datetime] NULL,
	[OrderSheetSuspensionStatusId] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Version] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
 CONSTRAINT [PK_OrderSheetSuspension] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheetSuspensionStatus]    Script Date: 7/12/2023 12:33:53 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheetSuspensionStatus](
	[Id] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_OrderSheetSuspensionStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderSheetType]    Script Date: 7/12/2023 12:33:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderSheetType](
	[Id] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
 CONSTRAINT [PK_OrderSheetType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pack]    Script Date: 7/12/2023 12:33:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pack](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[PackStatusId] [int] NOT NULL,
	[Batch] [varchar](50) NOT NULL,
	[ExpirationDate] [datetime] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedUserAccountId] [int] NULL,
	[Version] [int] NOT NULL,
	[ShippingDate] [datetime] NULL,
	[ReceptionDate] [datetime] NULL,
	[LaundryReceptionDate] [datetime] NULL,
	[RelatedPackId] [int] NULL,
 CONSTRAINT [PK_dbo.Pack] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackItem]    Script Date: 7/12/2023 12:33:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackItem](
	[PackId] [int] NOT NULL,
	[ItemId] [int] NOT NULL,
 CONSTRAINT [PK_PackItem] PRIMARY KEY CLUSTERED 
(
	[PackId] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackStatus]    Script Date: 7/12/2023 12:33:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackStatus](
	[Id] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PackStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Permission]    Script Date: 7/12/2023 12:33:54 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Permission](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[SysFunctionId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Permission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 7/12/2023 12:33:55 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Position] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Province]    Script Date: 7/12/2023 12:33:55 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Province](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Province] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionGuideDetail]    Script Date: 7/12/2023 12:33:55 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionGuideDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReceptionGuideId] [int] NOT NULL,
	[ItemId] [int] NULL,
	[ArticleId] [int] NULL,
	[ModelId] [int] NULL,
	[Quantity] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.ReceptionGuideDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionGuideError]    Script Date: 7/12/2023 12:33:55 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionGuideError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorStock] [int] NULL,
	[ErrorLost] [int] NULL,
	[ErrorDelete] [int] NULL,
	[ErrorPendSend] [int] NULL,
	[ErrorPendRead] [int] NULL,
	[IdReceptionGuide] [int] NOT NULL,
 CONSTRAINT [PK_ReceptionGuideError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionGuideErrorDetail]    Script Date: 7/12/2023 12:33:55 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionGuideErrorDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[IdReceptionGuideTypeError] [int] NOT NULL,
	[IdReceptionGuideError] [int] NOT NULL,
 CONSTRAINT [PK_ReceptionGuideErrorDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionGuideIncomplete]    Script Date: 7/12/2023 12:33:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionGuideIncomplete](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoadMap] [varchar](200) NULL,
	[Assign] [bit] NOT NULL,
	[Result] [varchar](max) NOT NULL,
	[Auto] [bit] NOT NULL,
	[LocationID] [int] NOT NULL,
	[LocationOriginId] [int] NULL,
	[SearchKey] [varchar](30) NULL,
 CONSTRAINT [PK_ReceptionGuideIncomplete] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionGuideIncompleteRemarks]    Script Date: 7/12/2023 12:33:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionGuideIncompleteRemarks](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoadMap] [varchar](200) NULL,
	[LocationID] [int] NOT NULL,
	[Remarks] [text] NULL,
 CONSTRAINT [PK_ReceptionGuideIncompleteRemarks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionGuidePack]    Script Date: 7/12/2023 12:33:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionGuidePack](
	[ReceptionGuideId] [int] NOT NULL,
	[PackId] [int] NOT NULL,
 CONSTRAINT [PK_ReceptionGuidePack] PRIMARY KEY CLUSTERED 
(
	[ReceptionGuideId] ASC,
	[PackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionGuideTypeError]    Script Date: 7/12/2023 12:33:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionGuideTypeError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ReceptionGuideTypeError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportPowerBI]    Script Date: 7/12/2023 12:33:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportPowerBI](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[WorkspaceId] [varchar](50) NULL,
	[ReportId] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Responsible]    Script Date: 7/12/2023 12:33:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Responsible](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Epc] [nvarchar](max) NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Surname] [nvarchar](max) NOT NULL,
	[Position] [nvarchar](max) NULL,
	[Dni] [int] NULL,
	[FileNumber] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[PhoneInt] [nvarchar](max) NULL,
	[CelularPhone] [nvarchar](max) NULL,
	[Nextel] [nvarchar](max) NULL,
	[ProfilePhoto] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[ExternalCode] [nvarchar](max) NULL,
	[PhoneIntGrilla] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Responsible] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoadMap]    Script Date: 7/12/2023 12:33:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoadMap](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoadMapNumber] [nvarchar](20) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[ShippingDate] [datetime] NULL,
	[ReceptionDate] [datetime] NULL,
	[RoadMapMovementTypeId] [int] NULL,
	[DeliveryNoteNumber] [varchar](20) NULL,
 CONSTRAINT [PK_dbo.RoadMap] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RoadMapNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoadMapAndShippingGuide]    Script Date: 7/12/2023 12:33:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoadMapAndShippingGuide](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShippingGuideId] [int] NOT NULL,
	[RoadMapId] [int] NOT NULL,
	[RoadMapMovementTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.RoadMapAndShippingGuide] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoadMapMovementsType]    Script Date: 7/12/2023 12:33:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoadMapMovementsType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.RoadMapMovementsType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 7/12/2023 12:33:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sector]    Script Date: 7/12/2023 12:33:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sector](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Sector] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shift]    Script Date: 7/12/2023 12:33:58 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shift](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[StartHour] [int] NOT NULL,
	[StartMinutes] [int] NOT NULL,
	[FinishHour] [int] NOT NULL,
	[FinishMinutes] [int] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.Shift] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingAndReception]    Script Date: 7/12/2023 12:33:58 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingAndReception](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShippingGuideId] [int] NOT NULL,
	[ReceptionGuideId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ShippingAndReception] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingContainer]    Script Date: 7/12/2023 12:33:58 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingContainer](
	[ShippingPackageId] [bigint] NOT NULL,
	[ContainerLocationId] [int] NOT NULL,
 CONSTRAINT [PK_ShippingContainer] PRIMARY KEY CLUSTERED 
(
	[ShippingPackageId] ASC,
	[ContainerLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideError]    Script Date: 7/12/2023 12:33:58 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ErrorStock] [int] NULL,
	[ErrorLost] [int] NULL,
	[ErrorTransit] [int] NULL,
	[ErrorDelete] [int] NULL,
	[ErrorPendSend] [int] NULL,
	[IdShippingGuide] [int] NOT NULL,
	[ErrorInOtherGuide] [int] NULL,
	[ErrorDelivered] [int] NULL,
 CONSTRAINT [PK_ShippingGuideError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideErrorDetail]    Script Date: 7/12/2023 12:33:58 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideErrorDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[IdShippingGuideTypeError] [int] NOT NULL,
	[IdShippingGuideError] [int] NOT NULL,
	[IdShippingGuideOrigin] [int] NULL,
 CONSTRAINT [PK_ShippingGuideErrorDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideIntermediate]    Script Date: 7/12/2023 12:33:58 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideIntermediate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdItem] [int] NOT NULL,
	[IdArticle] [int] NOT NULL,
	[PackageID] [int] NOT NULL,
	[OriginLocationID] [int] NOT NULL,
	[DestinationLocationID] [int] NOT NULL,
	[CheckPointID] [varchar](100) NOT NULL,
	[ShippingGuideID] [int] NOT NULL,
	[IsSerialized] [bit] NOT NULL,
	[OrderSheetId] [int] NULL,
	[Assign] [bit] NOT NULL,
	[ShippingGuideTypeErrorId] [int] NULL,
	[SharedShippingGuideNumber] [varchar](50) NULL,
	[ShippingPackageId] [bigint] NULL,
 CONSTRAINT [PK_ShippingGuideIntermediate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideIntermediateManual]    Script Date: 7/12/2023 12:33:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideIntermediateManual](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ModelId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[OriginLocationID] [int] NOT NULL,
	[DestinationLocationID] [int] NOT NULL,
	[CheckPointID] [varchar](100) NOT NULL,
	[ShippingGuideID] [int] NOT NULL,
	[IsSerialized] [bit] NOT NULL,
	[OrderSheetId] [int] NULL,
	[ArticleId] [int] NOT NULL,
	[Assign] [bit] NOT NULL,
 CONSTRAINT [PK_ShippingGuideIntermediateManual] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideMovementsType]    Script Date: 7/12/2023 12:33:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideMovementsType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.ShippingGuideMovementsType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuidePack]    Script Date: 7/12/2023 12:33:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuidePack](
	[ShippingGuideId] [int] NOT NULL,
	[PackId] [int] NOT NULL,
 CONSTRAINT [PK_ShippingGuidePack] PRIMARY KEY CLUSTERED 
(
	[ShippingGuideId] ASC,
	[PackId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideRestriction]    Script Date: 7/12/2023 12:33:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideRestriction](
	[Id] [int] NOT NULL,
	[StateAndLocationChange] [bit] NULL,
	[ItemsPerPackage] [bit] NULL,
	[MixedItems] [bit] NULL,
	[Brand] [bit] NULL,
	[ChildLocation] [bit] NULL,
	[RestrictLocations] [bit] NULL,
 CONSTRAINT [PK_ShippingGuideRestriction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideType]    Script Date: 7/12/2023 12:33:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideType](
	[Id] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ShippingGuideType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingGuideTypeError]    Script Date: 7/12/2023 12:34:00 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingGuideTypeError](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ShippingGuideTypeError] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingPackage]    Script Date: 7/12/2023 12:34:00 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingPackage](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PackageId] [int] NOT NULL,
	[Barcode] [varchar](50) NOT NULL,
	[Date] [datetime] NOT NULL,
	[UserAccountId] [int] NOT NULL,
 CONSTRAINT [PK_ShippingPackage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockAuditGuide]    Script Date: 7/12/2023 12:34:00 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockAuditGuide](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[LocationId] [int] NOT NULL,
	[UserAccountId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[OrderSheetId] [int] NULL,
 CONSTRAINT [PK_StockAudit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockAuditGuideDetail]    Script Date: 7/12/2023 12:34:00 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockAuditGuideDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StockAuditGuideId] [int] NOT NULL,
	[ItemId] [int] NULL,
	[ArticleId] [int] NULL,
	[ModelId] [int] NULL,
	[Quantity] [int] NOT NULL,
	[PreviousQuantity] [int] NULL,
 CONSTRAINT [PK_StockAuditGuideDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UK_StockAuditGuideDetail] UNIQUE NONCLUSTERED 
(
	[StockAuditGuideId] ASC,
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockLocation]    Script Date: 7/12/2023 12:34:00 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockLocation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [int] NOT NULL,
	[ArticleId] [int] NULL,
	[StockMax] [int] NOT NULL,
	[StockMin] [int] NOT NULL,
	[ModelId] [int] NULL,
 CONSTRAINT [PK_StockLocation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SysFunction]    Script Date: 7/12/2023 12:34:00 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysFunction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](80) NULL,
 CONSTRAINT [PK_dbo.SysFunction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SysParam]    Script Date: 7/12/2023 12:34:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysParam](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Value] [nvarchar](max) NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.SysParam] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccount]    Script Date: 7/12/2023 12:34:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Epc] [nvarchar](max) NULL,
	[Lang] [nvarchar](2) NOT NULL,
	[FileNumber] [nvarchar](50) NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](32) NOT NULL,
	[MustChangePassword] [bit] NOT NULL,
	[LastLogonDate] [datetime] NULL,
	[LocationId] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Email] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.UserAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccountLocation]    Script Date: 7/12/2023 12:34:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccountLocation](
	[UserAccountId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
 CONSTRAINT [PK_UserAccountLocation] PRIMARY KEY CLUSTERED 
(
	[UserAccountId] ASC,
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccountRole]    Script Date: 7/12/2023 12:34:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccountRole](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[UserAccountId] [int] NOT NULL,
	[Version] [int] NOT NULL,
	[CreationUserAccountId] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedUserAccountId] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.UserAccountRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ValidationRead]    Script Date: 7/12/2023 12:34:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ValidationRead](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ItemId] [int] NOT NULL,
	[ArticleId] [int] NOT NULL,
	[CheckpointId] [int] NOT NULL,
	[ReadDate] [datetime] NOT NULL,
	[IsReasigned] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.ValidationRead] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_CreationUserAccountId]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_CreationUserAccountId] ON [dbo].[AssetsScrapCause]
(
	[CreationUserAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ModifiedUserAccountId]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_ModifiedUserAccountId] ON [dbo].[AssetsScrapCause]
(
	[ModifiedUserAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_ItemId]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IDX_ItemId] ON [dbo].[AutomaticReceptionDetail]
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_FK_EmployeeCheckpoinRelease_Employee]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_FK_EmployeeCheckpoinRelease_Employee] ON [dbo].[EmployeeCheckpoinRelease]
(
	[EmployeeRelease_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ModelId]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_ModelId] ON [dbo].[PackageDetail]
(
	[ModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PackageId]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_PackageId] ON [dbo].[PackageDetail]
(
	[PackageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SGD_1]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_SGD_1] ON [dbo].[ShippingGuideDetail]
(
	[ShippingGuideId] ASC
)
INCLUDE ( 	[ItemId],
	[PackageDetailId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SGED_1]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_SGED_1] ON [dbo].[ShippingGuideErrorDetail]
(
	[ItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SGI_1]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_SGI_1] ON [dbo].[ShippingGuideIntermediate]
(
	[OriginLocationID] ASC
)
INCLUDE ( 	[Id],
	[IdItem],
	[PackageID],
	[DestinationLocationID],
	[ShippingGuideID],
	[Assign]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SGI_2]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_SGI_2] ON [dbo].[ShippingGuideIntermediate]
(
	[OrderSheetId] ASC,
	[Assign] ASC,
	[ShippingGuideID] ASC
)
INCLUDE ( 	[IdArticle]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShippingGuideIntermediate_20210920]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [IX_ShippingGuideIntermediate_20210920] ON [dbo].[ShippingGuideIntermediate]
(
	[OrderSheetId] ASC,
	[ShippingGuideID] ASC
)
INCLUDE ( 	[IdItem],
	[IdArticle]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_Code]    Script Date: 7/12/2023 12:34:02 p. m. ******/
CREATE NONCLUSTERED INDEX [idx_Code] ON [dbo].[SysFunction]
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Article] ADD  DEFAULT ((0)) FOR [Excluded]
GO
ALTER TABLE [dbo].[AssetsMovementsItems] ADD  DEFAULT ((0)) FOR [ModelId]
GO
ALTER TABLE [dbo].[AssetsMovementsItems] ADD  DEFAULT ((0)) FOR [ArticleId]
GO
ALTER TABLE [dbo].[AssetsTraceability] ADD  DEFAULT ((0)) FOR [AssetMovementTypeId]
GO
ALTER TABLE [dbo].[Category] ADD  DEFAULT ((0)) FOR [IsComposition]
GO
ALTER TABLE [dbo].[Location] ADD  DEFAULT ((0)) FOR [Laundry]
GO
ALTER TABLE [dbo].[Location] ADD  DEFAULT ((0)) FOR [SinRecepcion]
GO
ALTER TABLE [dbo].[Location] ADD  DEFAULT ((0)) FOR [LocationExterna]
GO
ALTER TABLE [dbo].[Location] ADD  DEFAULT ('0') FOR [AutoStartDelivery]
GO
ALTER TABLE [dbo].[Model] ADD  CONSTRAINT [DF_Model_EnableItemQuantityControlPerPackage]  DEFAULT ((1)) FOR [EnableItemQuantityControlPerPackage]
GO
ALTER TABLE [dbo].[Model] ADD  DEFAULT ((0)) FOR [IsPrimary]
GO
ALTER TABLE [dbo].[Model] ADD  DEFAULT ((0)) FOR [IsSecondary]
GO
ALTER TABLE [dbo].[OrderSheetItem] ADD  DEFAULT ((0)) FOR [SentQuantity]
GO
ALTER TABLE [dbo].[PackageDetail] ADD  DEFAULT ((0)) FOR [ModelId]
GO
ALTER TABLE [dbo].[PackageDetail] ADD  DEFAULT ((0)) FOR [PackageId]
GO
ALTER TABLE [dbo].[PackageDetail] ADD  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[PackageDetail] ADD  DEFAULT ((0)) FOR [DefaultForModel]
GO
ALTER TABLE [dbo].[ReceptionGuideIncomplete] ADD  CONSTRAINT [DF_ReceptionGuideIncomplete_Auto]  DEFAULT ((1)) FOR [Auto]
GO
ALTER TABLE [dbo].[ReceptionGuideIncomplete] ADD  CONSTRAINT [DF_ReceptionGuideIncomplete_LocationID]  DEFAULT ((0)) FOR [LocationID]
GO
ALTER TABLE [dbo].[ReceptionGuideIncompleteRemarks] ADD  CONSTRAINT [DF_ReceptionGuideIncompleteRemarks_LocationID]  DEFAULT ((0)) FOR [LocationID]
GO
ALTER TABLE [dbo].[RoadMap] ADD  DEFAULT ('1900-01-01T00:00:00.000') FOR [ShippingDate]
GO
ALTER TABLE [dbo].[RoadMap] ADD  DEFAULT ('1900-01-01T00:00:00.000') FOR [ReceptionDate]
GO
ALTER TABLE [dbo].[ShippingGuideDetail] ADD  DEFAULT ((0)) FOR [ArticleId]
GO
ALTER TABLE [dbo].[ShippingGuideIntermediate] ADD  CONSTRAINT [DF_ShippingGuideIntermediate_ShippingGuideID]  DEFAULT ((0)) FOR [ShippingGuideID]
GO
ALTER TABLE [dbo].[ShippingGuideIntermediate] ADD  CONSTRAINT [DF_ShippingGuideIntermediate_IsSerialized]  DEFAULT ((0)) FOR [IsSerialized]
GO
ALTER TABLE [dbo].[ShippingGuideIntermediate] ADD  CONSTRAINT [DF_ShippingGuideIntermediate_IsOrderSheet]  DEFAULT ((0)) FOR [OrderSheetId]
GO
ALTER TABLE [dbo].[ShippingGuideIntermediateManual] ADD  CONSTRAINT [DF_ShippingGuideIntermediateManual_ShippingGuideID]  DEFAULT ((0)) FOR [ShippingGuideID]
GO
ALTER TABLE [dbo].[ShippingGuideIntermediateManual] ADD  CONSTRAINT [DF_ShippingGuideIntermediateManual_IsSerialized]  DEFAULT ((0)) FOR [IsSerialized]
GO
ALTER TABLE [dbo].[ShippingGuideIntermediateManual] ADD  CONSTRAINT [DF_ShippingGuideIntermediateManual_IsOrderSheet]  DEFAULT ((0)) FOR [OrderSheetId]
GO
ALTER TABLE [dbo].[ValidationRead] ADD  DEFAULT ((0)) FOR [IsReasigned]
GO
ALTER TABLE [dbo].[Article]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Article_dbo.Brand_BrandId] FOREIGN KEY([BrandId])
REFERENCES [dbo].[Brand] ([Id])
GO
ALTER TABLE [dbo].[Article] CHECK CONSTRAINT [FK_dbo.Article_dbo.Brand_BrandId]
GO
ALTER TABLE [dbo].[Article]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Article_dbo.ColorArt_ColorArtId] FOREIGN KEY([ColorArtId])
REFERENCES [dbo].[ColorArt] ([Id])
GO
ALTER TABLE [dbo].[Article] CHECK CONSTRAINT [FK_dbo.Article_dbo.ColorArt_ColorArtId]
GO
ALTER TABLE [dbo].[Article]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Article_dbo.Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[Article] CHECK CONSTRAINT [FK_dbo.Article_dbo.Model_ModelId]
GO
ALTER TABLE [dbo].[Article]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Article_dbo.Size_SizeId] FOREIGN KEY([SizeId])
REFERENCES [dbo].[Size] ([Id])
GO
ALTER TABLE [dbo].[Article] CHECK CONSTRAINT [FK_dbo.Article_dbo.Size_SizeId]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH CHECK ADD  CONSTRAINT [FK_AssetsMovementsHeader_AuditGuide] FOREIGN KEY([AuditGuideId])
REFERENCES [dbo].[AuditGuide] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_AssetsMovementsHeader_AuditGuide]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH NOCHECK ADD  CONSTRAINT [FK_AssetsMovementsHeader_DeliveryGuide] FOREIGN KEY([DeliveryGuideId])
REFERENCES [dbo].[DeliveryGuide] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_AssetsMovementsHeader_DeliveryGuide]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH CHECK ADD  CONSTRAINT [FK_AssetsMovementsHeader_ReceptionGuide] FOREIGN KEY([ReceptionGuideId])
REFERENCES [dbo].[ReceptionGuide] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_AssetsMovementsHeader_ReceptionGuide]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH CHECK ADD  CONSTRAINT [FK_AssetsMovementsHeader_ShippingGuide] FOREIGN KEY([ShippingGuideId])
REFERENCES [dbo].[ShippingGuide] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_AssetsMovementsHeader_ShippingGuide]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.AssetsMovementsType_AssetMovementTypeId] FOREIGN KEY([AssetMovementTypeId])
REFERENCES [dbo].[AssetsMovementsType] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.AssetsMovementsType_AssetMovementTypeId]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.Location_DestinationLocationId] FOREIGN KEY([DestinationLocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.Location_DestinationLocationId]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.Location_SourceLocationId] FOREIGN KEY([SourceLocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.Location_SourceLocationId]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[AssetsMovementsHeader]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsHeader] CHECK CONSTRAINT [FK_dbo.AssetsMovementsHeader_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[AssetsMovementsItems]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsItems] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.Article_ArticleId]
GO
ALTER TABLE [dbo].[AssetsMovementsItems]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.AssetsMovementsHeader_AssetsMovementHeaderId] FOREIGN KEY([AssetsMovementHeaderId])
REFERENCES [dbo].[AssetsMovementsHeader] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsItems] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.AssetsMovementsHeader_AssetsMovementHeaderId]
GO
ALTER TABLE [dbo].[AssetsMovementsItems]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsItems] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.Model_ModelId]
GO
ALTER TABLE [dbo].[AssetsMovementsItems]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AssetsMovementsItems] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[AssetsMovementsItems]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsItems] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItems_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_AssetsMovementsItemsDetail_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail] CHECK CONSTRAINT [FK_AssetsMovementsItemsDetail_Article]
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItemsDetail_dbo.AssetsMovementsItems_AssetsMovementsItemId] FOREIGN KEY([AssetsMovementsItemId])
REFERENCES [dbo].[AssetsMovementsItems] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItemsDetail_dbo.AssetsMovementsItems_AssetsMovementsItemId]
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItemsDetail_dbo.Item_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItemsDetail_dbo.Item_ItemId]
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItemsDetail_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItemsDetail_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsMovementsItemsDetail_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AssetsMovementsItemsDetail] CHECK CONSTRAINT [FK_dbo.AssetsMovementsItemsDetail_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[AssetsScrapCause]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsScrapCause_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AssetsScrapCause] CHECK CONSTRAINT [FK_dbo.AssetsScrapCause_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[AssetsScrapCause]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AssetsScrapCause_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AssetsScrapCause] CHECK CONSTRAINT [FK_dbo.AssetsScrapCause_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[AssetsTraceability]  WITH NOCHECK ADD  CONSTRAINT [FK_AssetsTraceability_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[AssetsTraceability] CHECK CONSTRAINT [FK_AssetsTraceability_Article]
GO
ALTER TABLE [dbo].[AssetsTraceability]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsTraceability_dbo.AssetsMovementsType_AssetMovementTypeId] FOREIGN KEY([AssetMovementTypeId])
REFERENCES [dbo].[AssetsMovementsType] ([Id])
GO
ALTER TABLE [dbo].[AssetsTraceability] CHECK CONSTRAINT [FK_dbo.AssetsTraceability_dbo.AssetsMovementsType_AssetMovementTypeId]
GO
ALTER TABLE [dbo].[AssetsTraceability]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsTraceability_dbo.AssetsScrapCause_AssetScrapCauseId] FOREIGN KEY([AssetScrapCauseId])
REFERENCES [dbo].[AssetsScrapCause] ([Id])
GO
ALTER TABLE [dbo].[AssetsTraceability] CHECK CONSTRAINT [FK_dbo.AssetsTraceability_dbo.AssetsScrapCause_AssetScrapCauseId]
GO
ALTER TABLE [dbo].[AssetsTraceability]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsTraceability_dbo.Item_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[AssetsTraceability] CHECK CONSTRAINT [FK_dbo.AssetsTraceability_dbo.Item_ItemId]
GO
ALTER TABLE [dbo].[AssetsTraceability]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsTraceability_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[AssetsTraceability] CHECK CONSTRAINT [FK_dbo.AssetsTraceability_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[AssetsTraceability]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsTraceability_dbo.StateTags_StateTagId] FOREIGN KEY([StateTagId])
REFERENCES [dbo].[StateTags] ([Id])
GO
ALTER TABLE [dbo].[AssetsTraceability] CHECK CONSTRAINT [FK_dbo.AssetsTraceability_dbo.StateTags_StateTagId]
GO
ALTER TABLE [dbo].[AssetsTraceability]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsTraceability_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AssetsTraceability] CHECK CONSTRAINT [FK_dbo.AssetsTraceability_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[AssetsTraceability]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.AssetsTraceability_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AssetsTraceability] CHECK CONSTRAINT [FK_dbo.AssetsTraceability_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[AuditGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuide_dbo.Location_LocationOriginId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[AuditGuide] CHECK CONSTRAINT [FK_dbo.AuditGuide_dbo.Location_LocationOriginId]
GO
ALTER TABLE [dbo].[AuditGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuide_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AuditGuide] CHECK CONSTRAINT [FK_dbo.AuditGuide_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[AuditGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuide_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AuditGuide] CHECK CONSTRAINT [FK_dbo.AuditGuide_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[AuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideDetail] CHECK CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.Article_ArticleId]
GO
ALTER TABLE [dbo].[AuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.AuditGuide_AuditGuideId] FOREIGN KEY([AuditGuideId])
REFERENCES [dbo].[AuditGuide] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideDetail] CHECK CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.AuditGuide_AuditGuideId]
GO
ALTER TABLE [dbo].[AuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.Item_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideDetail] CHECK CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.Item_ItemId]
GO
ALTER TABLE [dbo].[AuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideDetail] CHECK CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.Model_ModelId]
GO
ALTER TABLE [dbo].[AuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.Pack_PackId] FOREIGN KEY([PackId])
REFERENCES [dbo].[Pack] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideDetail] CHECK CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.Pack_PackId]
GO
ALTER TABLE [dbo].[AuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AuditGuideDetail] CHECK CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[AuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideDetail] CHECK CONSTRAINT [FK_dbo.AuditGuideDetail_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[AuditGuideError]  WITH CHECK ADD  CONSTRAINT [FK_AuditGuideError_AuditGuide] FOREIGN KEY([AuditGuideId])
REFERENCES [dbo].[AuditGuide] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideError] CHECK CONSTRAINT [FK_AuditGuideError_AuditGuide]
GO
ALTER TABLE [dbo].[AuditGuideErrorDetail]  WITH CHECK ADD  CONSTRAINT [FK_AuditGuideErrorDetail_AuditGuideError] FOREIGN KEY([AuditGuideErrorId])
REFERENCES [dbo].[AuditGuideError] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideErrorDetail] CHECK CONSTRAINT [FK_AuditGuideErrorDetail_AuditGuideError]
GO
ALTER TABLE [dbo].[AuditGuideErrorDetail]  WITH CHECK ADD  CONSTRAINT [FK_AuditGuideErrorDetail_AuditGuideTypeError] FOREIGN KEY([AuditGuideTypeErrorId])
REFERENCES [dbo].[AuditGuideTypeError] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideErrorDetail] CHECK CONSTRAINT [FK_AuditGuideErrorDetail_AuditGuideTypeError]
GO
ALTER TABLE [dbo].[AuditGuideErrorDetail]  WITH CHECK ADD  CONSTRAINT [FK_AuditGuideErrorDetail_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideErrorDetail] CHECK CONSTRAINT [FK_AuditGuideErrorDetail_Item]
GO
ALTER TABLE [dbo].[AuditGuideRow]  WITH CHECK ADD  CONSTRAINT [FK_AuditGuideRow_AuditGuideTypeError] FOREIGN KEY([AuditGuideTypeErrorId])
REFERENCES [dbo].[AuditGuideTypeError] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideRow] CHECK CONSTRAINT [FK_AuditGuideRow_AuditGuideTypeError]
GO
ALTER TABLE [dbo].[AuditGuideRow]  WITH CHECK ADD  CONSTRAINT [FK_AuditGuideRow_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideRow] CHECK CONSTRAINT [FK_AuditGuideRow_Item]
GO
ALTER TABLE [dbo].[AuditGuideRow]  WITH CHECK ADD  CONSTRAINT [FK_AuditGuideRow_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[AuditGuideRow] CHECK CONSTRAINT [FK_AuditGuideRow_Location]
GO
ALTER TABLE [dbo].[AuthorizationLog]  WITH CHECK ADD  CONSTRAINT [FK_AuthorizationLog_DeliveryGuide] FOREIGN KEY([DeliveryGuideId])
REFERENCES [dbo].[DeliveryGuide] ([Id])
GO
ALTER TABLE [dbo].[AuthorizationLog] CHECK CONSTRAINT [FK_AuthorizationLog_DeliveryGuide]
GO
ALTER TABLE [dbo].[AuthorizationLog]  WITH CHECK ADD  CONSTRAINT [FK_AuthorizationLog_OrderSheet] FOREIGN KEY([OrderSheetId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[AuthorizationLog] CHECK CONSTRAINT [FK_AuthorizationLog_OrderSheet]
GO
ALTER TABLE [dbo].[AuthorizationLog]  WITH CHECK ADD  CONSTRAINT [FK_AuthorizationLog_ReceptionGuide] FOREIGN KEY([ReceptionGuideId])
REFERENCES [dbo].[ReceptionGuide] ([Id])
GO
ALTER TABLE [dbo].[AuthorizationLog] CHECK CONSTRAINT [FK_AuthorizationLog_ReceptionGuide]
GO
ALTER TABLE [dbo].[AuthorizationLog]  WITH CHECK ADD  CONSTRAINT [FK_AuthorizationLog_ShippingGuide] FOREIGN KEY([ShippingGuideId])
REFERENCES [dbo].[ShippingGuide] ([Id])
GO
ALTER TABLE [dbo].[AuthorizationLog] CHECK CONSTRAINT [FK_AuthorizationLog_ShippingGuide]
GO
ALTER TABLE [dbo].[AuthorizationLog]  WITH CHECK ADD  CONSTRAINT [FK_AuthorizationLog_SysFunction] FOREIGN KEY([SysFunctionId])
REFERENCES [dbo].[SysFunction] ([Id])
GO
ALTER TABLE [dbo].[AuthorizationLog] CHECK CONSTRAINT [FK_AuthorizationLog_SysFunction]
GO
ALTER TABLE [dbo].[AuthorizationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuthorizationLog_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AuthorizationLog] CHECK CONSTRAINT [FK_dbo.AuthorizationLog_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[AutomaticReception]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticReception_Location] FOREIGN KEY([LocationOriginId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[AutomaticReception] CHECK CONSTRAINT [FK_AutomaticReception_Location]
GO
ALTER TABLE [dbo].[AutomaticReception]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticReception_Location1] FOREIGN KEY([LocationDestinationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[AutomaticReception] CHECK CONSTRAINT [FK_AutomaticReception_Location1]
GO
ALTER TABLE [dbo].[AutomaticReception]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticReception_ReceptionGuide] FOREIGN KEY([ReceptionGuideId])
REFERENCES [dbo].[ReceptionGuide] ([Id])
GO
ALTER TABLE [dbo].[AutomaticReception] CHECK CONSTRAINT [FK_AutomaticReception_ReceptionGuide]
GO
ALTER TABLE [dbo].[AutomaticReception]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticReception_UserAccount] FOREIGN KEY([UserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[AutomaticReception] CHECK CONSTRAINT [FK_AutomaticReception_UserAccount]
GO
ALTER TABLE [dbo].[AutomaticReceptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticReceptionDetail_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[AutomaticReceptionDetail] CHECK CONSTRAINT [FK_AutomaticReceptionDetail_Article]
GO
ALTER TABLE [dbo].[AutomaticReceptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticReceptionDetail_AutomaticReception] FOREIGN KEY([AutomaticReceptionId])
REFERENCES [dbo].[AutomaticReception] ([Id])
GO
ALTER TABLE [dbo].[AutomaticReceptionDetail] CHECK CONSTRAINT [FK_AutomaticReceptionDetail_AutomaticReception]
GO
ALTER TABLE [dbo].[AutomaticReceptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticReceptionDetail_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[AutomaticReceptionDetail] CHECK CONSTRAINT [FK_AutomaticReceptionDetail_Item]
GO
ALTER TABLE [dbo].[AutomaticReceptionDetail]  WITH CHECK ADD  CONSTRAINT [FK_AutomaticReceptionDetail_Model] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[AutomaticReceptionDetail] CHECK CONSTRAINT [FK_AutomaticReceptionDetail_Model]
GO
ALTER TABLE [dbo].[Brand]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Brand_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Brand] CHECK CONSTRAINT [FK_dbo.Brand_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Brand]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Brand_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Brand] CHECK CONSTRAINT [FK_dbo.Brand_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[BrandLocation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.BrandLocation_dbo.Brand_BrandId] FOREIGN KEY([BrandId])
REFERENCES [dbo].[Brand] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BrandLocation] CHECK CONSTRAINT [FK_dbo.BrandLocation_dbo.Brand_BrandId]
GO
ALTER TABLE [dbo].[BrandLocation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.BrandLocation_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BrandLocation] CHECK CONSTRAINT [FK_dbo.BrandLocation_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[BrandLocation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.BrandLocation_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[BrandLocation] CHECK CONSTRAINT [FK_dbo.BrandLocation_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[BrandLocation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.BrandLocation_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[BrandLocation] CHECK CONSTRAINT [FK_dbo.BrandLocation_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Category]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Category_dbo.Category_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[Category] CHECK CONSTRAINT [FK_dbo.Category_dbo.Category_ParentId]
GO
ALTER TABLE [dbo].[Category]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Category_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Category] CHECK CONSTRAINT [FK_dbo.Category_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Category]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Category_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Category] CHECK CONSTRAINT [FK_dbo.Category_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[CheckPoint]  WITH CHECK ADD  CONSTRAINT [FK_CheckPoint_CheckpointType] FOREIGN KEY([CheckpointTypeId])
REFERENCES [dbo].[CheckpointType] ([Id])
GO
ALTER TABLE [dbo].[CheckPoint] CHECK CONSTRAINT [FK_CheckPoint_CheckpointType]
GO
ALTER TABLE [dbo].[CheckpointGroup]  WITH CHECK ADD  CONSTRAINT [FK_CheckpointGroup_CreationUserAccount] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[CheckpointGroup] CHECK CONSTRAINT [FK_CheckpointGroup_CreationUserAccount]
GO
ALTER TABLE [dbo].[CheckpointGroup]  WITH CHECK ADD  CONSTRAINT [FK_CheckpointGroup_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[CheckpointGroup] CHECK CONSTRAINT [FK_CheckpointGroup_Location]
GO
ALTER TABLE [dbo].[CheckpointGroup]  WITH CHECK ADD  CONSTRAINT [FK_CheckpointGroup_ModifiedUserAccount] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[CheckpointGroup] CHECK CONSTRAINT [FK_CheckpointGroup_ModifiedUserAccount]
GO
ALTER TABLE [dbo].[CheckpointInGroup]  WITH CHECK ADD  CONSTRAINT [FK_CheckpointInGroup_CheckPoint] FOREIGN KEY([CheckpointId])
REFERENCES [dbo].[CheckPoint] ([Id])
GO
ALTER TABLE [dbo].[CheckpointInGroup] CHECK CONSTRAINT [FK_CheckpointInGroup_CheckPoint]
GO
ALTER TABLE [dbo].[CheckpointInGroup]  WITH CHECK ADD  CONSTRAINT [FK_CheckpointInGroup_CheckpointGroup] FOREIGN KEY([CheckpointGroupId])
REFERENCES [dbo].[CheckpointGroup] ([Id])
GO
ALTER TABLE [dbo].[CheckpointInGroup] CHECK CONSTRAINT [FK_CheckpointInGroup_CheckpointGroup]
GO
ALTER TABLE [dbo].[Container]  WITH CHECK ADD  CONSTRAINT [FK_Container_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Container] CHECK CONSTRAINT [FK_Container_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Container]  WITH CHECK ADD  CONSTRAINT [FK_Container_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Container] CHECK CONSTRAINT [FK_Container_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[ContainerExit]  WITH CHECK ADD  CONSTRAINT [FK_ContainerExit_CheckPoint] FOREIGN KEY([CheckpointId])
REFERENCES [dbo].[CheckPoint] ([Id])
GO
ALTER TABLE [dbo].[ContainerExit] CHECK CONSTRAINT [FK_ContainerExit_CheckPoint]
GO
ALTER TABLE [dbo].[ContainerExit]  WITH CHECK ADD  CONSTRAINT [FK_ContainerExit_Container] FOREIGN KEY([ContainerId])
REFERENCES [dbo].[Container] ([Id])
GO
ALTER TABLE [dbo].[ContainerExit] CHECK CONSTRAINT [FK_ContainerExit_Container]
GO
ALTER TABLE [dbo].[ContainerExit]  WITH CHECK ADD  CONSTRAINT [FK_ContainerExit_Location] FOREIGN KEY([DestinationLocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[ContainerExit] CHECK CONSTRAINT [FK_ContainerExit_Location]
GO
ALTER TABLE [dbo].[ContainerLocation]  WITH CHECK ADD  CONSTRAINT [FK_ContainerLocation_Container] FOREIGN KEY([ContainerId])
REFERENCES [dbo].[Container] ([Id])
GO
ALTER TABLE [dbo].[ContainerLocation] CHECK CONSTRAINT [FK_ContainerLocation_Container]
GO
ALTER TABLE [dbo].[ContainerLocation]  WITH CHECK ADD  CONSTRAINT [FK_ContainerLocation_LocationDestination] FOREIGN KEY([LocationDestinationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[ContainerLocation] CHECK CONSTRAINT [FK_ContainerLocation_LocationDestination]
GO
ALTER TABLE [dbo].[ContainerLocation]  WITH CHECK ADD  CONSTRAINT [FK_ContainerLocation_LocationOrigin] FOREIGN KEY([LocationOriginId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[ContainerLocation] CHECK CONSTRAINT [FK_ContainerLocation_LocationOrigin]
GO
ALTER TABLE [dbo].[ContainerLocationItem]  WITH CHECK ADD  CONSTRAINT [FK_ContainerLocationItem_ContainerLocation] FOREIGN KEY([ContainerLocationId])
REFERENCES [dbo].[ContainerLocation] ([Id])
GO
ALTER TABLE [dbo].[ContainerLocationItem] CHECK CONSTRAINT [FK_ContainerLocationItem_ContainerLocation]
GO
ALTER TABLE [dbo].[ContainerLocationItem]  WITH CHECK ADD  CONSTRAINT [FK_ContainerLocationItem_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[ContainerLocationItem] CHECK CONSTRAINT [FK_ContainerLocationItem_Item]
GO
ALTER TABLE [dbo].[ContainerLocationItemError]  WITH CHECK ADD  CONSTRAINT [FK_ContainerLocationItemError_ContainerLocation] FOREIGN KEY([ContainerLocationId])
REFERENCES [dbo].[ContainerLocation] ([Id])
GO
ALTER TABLE [dbo].[ContainerLocationItemError] CHECK CONSTRAINT [FK_ContainerLocationItemError_ContainerLocation]
GO
ALTER TABLE [dbo].[ContainerLocationItemError]  WITH CHECK ADD  CONSTRAINT [FK_ContainerLocationItemError_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[ContainerLocationItemError] CHECK CONSTRAINT [FK_ContainerLocationItemError_Item]
GO
ALTER TABLE [dbo].[CostCenter]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CostCenter_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CostCenter] CHECK CONSTRAINT [FK_dbo.CostCenter_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[CostCenter]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CostCenter_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[CostCenter] CHECK CONSTRAINT [FK_dbo.CostCenter_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[DeliveryGuide]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuide_dbo.Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[DeliveryGuide] CHECK CONSTRAINT [FK_dbo.DeliveryGuide_dbo.Employee_EmployeeId]
GO
ALTER TABLE [dbo].[DeliveryGuide]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuide_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DeliveryGuide] CHECK CONSTRAINT [FK_dbo.DeliveryGuide_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[DeliveryGuide]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuide_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[DeliveryGuide] CHECK CONSTRAINT [FK_dbo.DeliveryGuide_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[DeliveryGuide]  WITH CHECK ADD  CONSTRAINT [FK_DeliveryGuide_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[DeliveryGuide] CHECK CONSTRAINT [FK_DeliveryGuide_Location]
GO
ALTER TABLE [dbo].[DeliveryGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[DeliveryGuideDetail] CHECK CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.Article_ArticleId]
GO
ALTER TABLE [dbo].[DeliveryGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.DeliveryGuide_DeliveryGuideId] FOREIGN KEY([DeliveryGuideId])
REFERENCES [dbo].[DeliveryGuide] ([Id])
GO
ALTER TABLE [dbo].[DeliveryGuideDetail] CHECK CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.DeliveryGuide_DeliveryGuideId]
GO
ALTER TABLE [dbo].[DeliveryGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.Item_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[DeliveryGuideDetail] CHECK CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.Item_ItemId]
GO
ALTER TABLE [dbo].[DeliveryGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[DeliveryGuideDetail] CHECK CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.Model_ModelId]
GO
ALTER TABLE [dbo].[DeliveryGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DeliveryGuideDetail] CHECK CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[DeliveryGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[DeliveryGuideDetail] CHECK CONSTRAINT [FK_dbo.DeliveryGuideDetail_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Employee]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.Employee_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_dbo.Employee_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Employee]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.Employee_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_dbo.Employee_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_DocumentType] FOREIGN KEY([DocumentTypeId])
REFERENCES [dbo].[DocumentType] ([Id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_DocumentType]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Position] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([Id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Position]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Sector] FOREIGN KEY([SectorId])
REFERENCES [dbo].[Sector] ([Id])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Sector]
GO
ALTER TABLE [dbo].[EmployeeCheckpoinRelease]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCheckpoinRelease_CheckPoint] FOREIGN KEY([CheckPointRelease_Id])
REFERENCES [dbo].[CheckPoint] ([Id])
GO
ALTER TABLE [dbo].[EmployeeCheckpoinRelease] CHECK CONSTRAINT [FK_EmployeeCheckpoinRelease_CheckPoint]
GO
ALTER TABLE [dbo].[EmployeeCheckpoinRelease]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCheckpoinRelease_Employee] FOREIGN KEY([EmployeeRelease_Id])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[EmployeeCheckpoinRelease] CHECK CONSTRAINT [FK_EmployeeCheckpoinRelease_Employee]
GO
ALTER TABLE [dbo].[EmployeeFingerprint]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeFingerprint_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[EmployeeFingerprint] CHECK CONSTRAINT [FK_EmployeeFingerprint_Employee]
GO
ALTER TABLE [dbo].[EmployeeFingerprint]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeFingerprint_Fingerprint] FOREIGN KEY([FingerprintId])
REFERENCES [dbo].[Fingerprint] ([Id])
GO
ALTER TABLE [dbo].[EmployeeFingerprint] CHECK CONSTRAINT [FK_EmployeeFingerprint_Fingerprint]
GO
ALTER TABLE [dbo].[EventLog]  WITH CHECK ADD  CONSTRAINT [FK_EventLog_EventLogType] FOREIGN KEY([EventLogTypeId])
REFERENCES [dbo].[EventLogType] ([Id])
GO
ALTER TABLE [dbo].[EventLog] CHECK CONSTRAINT [FK_EventLog_EventLogType]
GO
ALTER TABLE [dbo].[EventLog]  WITH CHECK ADD  CONSTRAINT [FK_EventLog_UserAccount] FOREIGN KEY([UserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[EventLog] CHECK CONSTRAINT [FK_EventLog_UserAccount]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Item_dbo.Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_dbo.Item_dbo.Article_ArticleId]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Item_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_dbo.Item_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Item_dbo.StateTags_StateTagsId] FOREIGN KEY([StateTagsId])
REFERENCES [dbo].[StateTags] ([Id])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_dbo.Item_dbo.StateTags_StateTagsId]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Item_dbo.Supplier_SupplierId] FOREIGN KEY([SupplierId])
REFERENCES [dbo].[Supplier] ([Id])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_dbo.Item_dbo.Supplier_SupplierId]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Item_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_dbo.Item_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Item_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_dbo.Item_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.CostCenter_CostCenterId] FOREIGN KEY([CostCenterId])
REFERENCES [dbo].[CostCenter] ([Id])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.CostCenter_CostCenterId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.Location_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.Location_ParentId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_Location_Province] FOREIGN KEY([ProvinceId])
REFERENCES [dbo].[Province] ([Id])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_Location_Province]
GO
ALTER TABLE [dbo].[LocationResponsible]  WITH CHECK ADD  CONSTRAINT [FK_dbo.LocationResponsible_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LocationResponsible] CHECK CONSTRAINT [FK_dbo.LocationResponsible_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[LocationResponsible]  WITH CHECK ADD  CONSTRAINT [FK_dbo.LocationResponsible_dbo.Responsible_ResponsibleId] FOREIGN KEY([ResponsibleId])
REFERENCES [dbo].[Responsible] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LocationResponsible] CHECK CONSTRAINT [FK_dbo.LocationResponsible_dbo.Responsible_ResponsibleId]
GO
ALTER TABLE [dbo].[LocationResponsible]  WITH CHECK ADD  CONSTRAINT [FK_dbo.LocationResponsible_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[LocationResponsible] CHECK CONSTRAINT [FK_dbo.LocationResponsible_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[LocationResponsible]  WITH CHECK ADD  CONSTRAINT [FK_dbo.LocationResponsible_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[LocationResponsible] CHECK CONSTRAINT [FK_dbo.LocationResponsible_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Model]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Model_dbo.Category_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[Model] CHECK CONSTRAINT [FK_dbo.Model_dbo.Category_CategoryId]
GO
ALTER TABLE [dbo].[Model]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Model_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Model] CHECK CONSTRAINT [FK_dbo.Model_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Model]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Model_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Model] CHECK CONSTRAINT [FK_dbo.Model_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Monitor]  WITH CHECK ADD  CONSTRAINT [FK_Monitor_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[Monitor] CHECK CONSTRAINT [FK_Monitor_Article]
GO
ALTER TABLE [dbo].[Monitor]  WITH CHECK ADD  CONSTRAINT [FK_Monitor_CheckPoint] FOREIGN KEY([CheckpointId])
REFERENCES [dbo].[CheckPoint] ([Id])
GO
ALTER TABLE [dbo].[Monitor] CHECK CONSTRAINT [FK_Monitor_CheckPoint]
GO
ALTER TABLE [dbo].[Monitor]  WITH CHECK ADD  CONSTRAINT [FK_Monitor_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO
ALTER TABLE [dbo].[Monitor] CHECK CONSTRAINT [FK_Monitor_Employee]
GO
ALTER TABLE [dbo].[Monitor]  WITH CHECK ADD  CONSTRAINT [FK_Monitor_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[Monitor] CHECK CONSTRAINT [FK_Monitor_Item]
GO
ALTER TABLE [dbo].[Monitor]  WITH CHECK ADD  CONSTRAINT [FK_Monitor_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[Monitor] CHECK CONSTRAINT [FK_Monitor_Location]
GO
ALTER TABLE [dbo].[Monitor]  WITH CHECK ADD  CONSTRAINT [FK_Monitor_Model] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[Monitor] CHECK CONSTRAINT [FK_Monitor_Model]
GO
ALTER TABLE [dbo].[Monitor]  WITH CHECK ADD  CONSTRAINT [FK_Monitor_StateTags] FOREIGN KEY([StateTagsId])
REFERENCES [dbo].[StateTags] ([Id])
GO
ALTER TABLE [dbo].[Monitor] CHECK CONSTRAINT [FK_Monitor_StateTags]
GO
ALTER TABLE [dbo].[OrderSheet]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrderSheet_dbo.OrderSheetStatus_OrderSheetStatusId] FOREIGN KEY([OrderSheetStatusId])
REFERENCES [dbo].[OrderSheetStatus] ([Id])
GO
ALTER TABLE [dbo].[OrderSheet] CHECK CONSTRAINT [FK_dbo.OrderSheet_dbo.OrderSheetStatus_OrderSheetStatusId]
GO
ALTER TABLE [dbo].[OrderSheet]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrderSheet_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[OrderSheet] CHECK CONSTRAINT [FK_dbo.OrderSheet_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[OrderSheet]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrderSheet_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[OrderSheet] CHECK CONSTRAINT [FK_dbo.OrderSheet_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[OrderSheet]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheet_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[OrderSheet] CHECK CONSTRAINT [FK_OrderSheet_Location]
GO
ALTER TABLE [dbo].[OrderSheet]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheet_OrderSheet] FOREIGN KEY([ParentOrderSheetId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[OrderSheet] CHECK CONSTRAINT [FK_OrderSheet_OrderSheet]
GO
ALTER TABLE [dbo].[OrderSheet]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheet_OrderSheetType] FOREIGN KEY([OrderSheetTypeId])
REFERENCES [dbo].[OrderSheetType] ([Id])
GO
ALTER TABLE [dbo].[OrderSheet] CHECK CONSTRAINT [FK_OrderSheet_OrderSheetType]
GO
ALTER TABLE [dbo].[OrderSheetAdvance]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetAdvance_dbo.Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetAdvance] CHECK CONSTRAINT [FK_OrderSheetAdvance_dbo.Article_ArticleId]
GO
ALTER TABLE [dbo].[OrderSheetAdvance]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetAdvance_OrderSheet] FOREIGN KEY([OrderSheetRequestedId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetAdvance] CHECK CONSTRAINT [FK_OrderSheetAdvance_OrderSheet]
GO
ALTER TABLE [dbo].[OrderSheetAdvance]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetAdvance_OrderSheetAccepted] FOREIGN KEY([OrderSheetAcceptedId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetAdvance] CHECK CONSTRAINT [FK_OrderSheetAdvance_OrderSheetAccepted]
GO
ALTER TABLE [dbo].[OrderSheetAdvance]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetAdvance_OrderSheetAdvanceLocation] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetAdvance] CHECK CONSTRAINT [FK_OrderSheetAdvance_OrderSheetAdvanceLocation]
GO
ALTER TABLE [dbo].[OrderSheetAdvance]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetAdvance_OrderSheetAdvanceStatus] FOREIGN KEY([OrderSheetAdvanceStatusId])
REFERENCES [dbo].[OrderSheetAdvanceStatus] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetAdvance] CHECK CONSTRAINT [FK_OrderSheetAdvance_OrderSheetAdvanceStatus]
GO
ALTER TABLE [dbo].[OrderSheetDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetDetail_Model] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetDetail] CHECK CONSTRAINT [FK_OrderSheetDetail_Model]
GO
ALTER TABLE [dbo].[OrderSheetDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetDetail_OrderSheet] FOREIGN KEY([OrderSheetId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetDetail] CHECK CONSTRAINT [FK_OrderSheetDetail_OrderSheet]
GO
ALTER TABLE [dbo].[OrderSheetItem]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrderSheetItem_dbo.Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetItem] CHECK CONSTRAINT [FK_dbo.OrderSheetItem_dbo.Article_ArticleId]
GO
ALTER TABLE [dbo].[OrderSheetItem]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrderSheetItem_dbo.Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetItem] CHECK CONSTRAINT [FK_dbo.OrderSheetItem_dbo.Model_ModelId]
GO
ALTER TABLE [dbo].[OrderSheetItem]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrderSheetItem_dbo.OrderSheet_OrderSheetId] FOREIGN KEY([OrderSheetId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetItem] CHECK CONSTRAINT [FK_dbo.OrderSheetItem_dbo.OrderSheet_OrderSheetId]
GO
ALTER TABLE [dbo].[OrderSheetItem]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrderSheetItem_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderSheetItem] CHECK CONSTRAINT [FK_dbo.OrderSheetItem_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[OrderSheetItem]  WITH CHECK ADD  CONSTRAINT [FK_dbo.OrderSheetItem_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetItem] CHECK CONSTRAINT [FK_dbo.OrderSheetItem_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[OrderSheetItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetItem_GenerationType] FOREIGN KEY([GenerationTypeId])
REFERENCES [dbo].[GenerationType] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetItem] CHECK CONSTRAINT [FK_OrderSheetItem_GenerationType]
GO
ALTER TABLE [dbo].[OrderSheetSuspension]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderSheetSuspension_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetSuspension] CHECK CONSTRAINT [FK_OrderSheetSuspension_Article]
GO
ALTER TABLE [dbo].[OrderSheetSuspension]  WITH CHECK ADD  CONSTRAINT [FK_OrderSheetSuspension_OrderSheetSuspensionLocation] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetSuspension] CHECK CONSTRAINT [FK_OrderSheetSuspension_OrderSheetSuspensionLocation]
GO
ALTER TABLE [dbo].[OrderSheetSuspension]  WITH NOCHECK ADD  CONSTRAINT [FK_OrderSheetSuspension_OrderSheetSuspensionStatus] FOREIGN KEY([OrderSheetSuspensionStatusId])
REFERENCES [dbo].[OrderSheetSuspensionStatus] ([Id])
GO
ALTER TABLE [dbo].[OrderSheetSuspension] CHECK CONSTRAINT [FK_OrderSheetSuspension_OrderSheetSuspensionStatus]
GO
ALTER TABLE [dbo].[Pack]  WITH CHECK ADD  CONSTRAINT [FK_Pack_CreationUserAccount] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Pack] CHECK CONSTRAINT [FK_Pack_CreationUserAccount]
GO
ALTER TABLE [dbo].[Pack]  WITH CHECK ADD  CONSTRAINT [FK_Pack_ModifiedUserAccount] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Pack] CHECK CONSTRAINT [FK_Pack_ModifiedUserAccount]
GO
ALTER TABLE [dbo].[Pack]  WITH CHECK ADD  CONSTRAINT [FK_Pack_Package] FOREIGN KEY([PackageId])
REFERENCES [dbo].[Package] ([Id])
GO
ALTER TABLE [dbo].[Pack] CHECK CONSTRAINT [FK_Pack_Package]
GO
ALTER TABLE [dbo].[Pack]  WITH CHECK ADD  CONSTRAINT [FK_Pack_PackStatus] FOREIGN KEY([PackStatusId])
REFERENCES [dbo].[PackStatus] ([Id])
GO
ALTER TABLE [dbo].[Pack] CHECK CONSTRAINT [FK_Pack_PackStatus]
GO
ALTER TABLE [dbo].[PackageDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PackageDetail_dbo.Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[PackageDetail] CHECK CONSTRAINT [FK_dbo.PackageDetail_dbo.Model_ModelId]
GO
ALTER TABLE [dbo].[PackageDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PackageDetail_dbo.Package_PackageId] FOREIGN KEY([PackageId])
REFERENCES [dbo].[Package] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PackageDetail] CHECK CONSTRAINT [FK_dbo.PackageDetail_dbo.Package_PackageId]
GO
ALTER TABLE [dbo].[PackItem]  WITH CHECK ADD  CONSTRAINT [FK_PackItem_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[PackItem] CHECK CONSTRAINT [FK_PackItem_Item]
GO
ALTER TABLE [dbo].[PackItem]  WITH CHECK ADD  CONSTRAINT [FK_PackItem_Pack] FOREIGN KEY([PackId])
REFERENCES [dbo].[Pack] ([Id])
GO
ALTER TABLE [dbo].[PackItem] CHECK CONSTRAINT [FK_PackItem_Pack]
GO
ALTER TABLE [dbo].[Permission]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Permission_dbo.Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Permission] CHECK CONSTRAINT [FK_dbo.Permission_dbo.Role_RoleId]
GO
ALTER TABLE [dbo].[Permission]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Permission_dbo.SysFunction_SysFunctionId] FOREIGN KEY([SysFunctionId])
REFERENCES [dbo].[SysFunction] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Permission] CHECK CONSTRAINT [FK_dbo.Permission_dbo.SysFunction_SysFunctionId]
GO
ALTER TABLE [dbo].[Permission]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Permission_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Permission] CHECK CONSTRAINT [FK_dbo.Permission_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Permission]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Permission_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Permission] CHECK CONSTRAINT [FK_dbo.Permission_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Position_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [FK_dbo.Position_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Position_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [FK_dbo.Position_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Province]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Province_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Province] CHECK CONSTRAINT [FK_dbo.Province_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Province]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Province_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Province] CHECK CONSTRAINT [FK_dbo.Province_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[ReceptionGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuide_dbo.Location_LocationOriginId] FOREIGN KEY([LocationDestinationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuide] CHECK CONSTRAINT [FK_dbo.ReceptionGuide_dbo.Location_LocationOriginId]
GO
ALTER TABLE [dbo].[ReceptionGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuide_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReceptionGuide] CHECK CONSTRAINT [FK_dbo.ReceptionGuide_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[ReceptionGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuide_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuide] CHECK CONSTRAINT [FK_dbo.ReceptionGuide_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[ReceptionGuide]  WITH CHECK ADD  CONSTRAINT [FK_ReceptionGuide_Location] FOREIGN KEY([LocationOriginId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuide] CHECK CONSTRAINT [FK_ReceptionGuide_Location]
GO
ALTER TABLE [dbo].[ReceptionGuide]  WITH CHECK ADD  CONSTRAINT [FK_ReceptionGuide_OrderSheet] FOREIGN KEY([OrderSheetId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuide] CHECK CONSTRAINT [FK_ReceptionGuide_OrderSheet]
GO
ALTER TABLE [dbo].[ReceptionGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideDetail] CHECK CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.Article_ArticleId]
GO
ALTER TABLE [dbo].[ReceptionGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.Item_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideDetail] CHECK CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.Item_ItemId]
GO
ALTER TABLE [dbo].[ReceptionGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideDetail] CHECK CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.Model_ModelId]
GO
ALTER TABLE [dbo].[ReceptionGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.ReceptionGuide_ReceptionGuideId] FOREIGN KEY([ReceptionGuideId])
REFERENCES [dbo].[ReceptionGuide] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideDetail] CHECK CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.ReceptionGuide_ReceptionGuideId]
GO
ALTER TABLE [dbo].[ReceptionGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReceptionGuideDetail] CHECK CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[ReceptionGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideDetail] CHECK CONSTRAINT [FK_dbo.ReceptionGuideDetail_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[ReceptionGuideError]  WITH CHECK ADD  CONSTRAINT [FK_ReceptionGuideError_ReceptionGuide] FOREIGN KEY([IdReceptionGuide])
REFERENCES [dbo].[ReceptionGuide] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideError] CHECK CONSTRAINT [FK_ReceptionGuideError_ReceptionGuide]
GO
ALTER TABLE [dbo].[ReceptionGuideErrorDetail]  WITH CHECK ADD  CONSTRAINT [FK_ReceptionGuideErrorDetail_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideErrorDetail] CHECK CONSTRAINT [FK_ReceptionGuideErrorDetail_Item]
GO
ALTER TABLE [dbo].[ReceptionGuideErrorDetail]  WITH CHECK ADD  CONSTRAINT [FK_ReceptionGuideErrorDetail_ReceptionGuideError] FOREIGN KEY([IdReceptionGuideError])
REFERENCES [dbo].[ReceptionGuideError] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideErrorDetail] CHECK CONSTRAINT [FK_ReceptionGuideErrorDetail_ReceptionGuideError]
GO
ALTER TABLE [dbo].[ReceptionGuideErrorDetail]  WITH CHECK ADD  CONSTRAINT [FK_ReceptionGuideErrorDetail_ReceptionGuideTypeError] FOREIGN KEY([IdReceptionGuideTypeError])
REFERENCES [dbo].[ReceptionGuideTypeError] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuideErrorDetail] CHECK CONSTRAINT [FK_ReceptionGuideErrorDetail_ReceptionGuideTypeError]
GO
ALTER TABLE [dbo].[ReceptionGuidePack]  WITH CHECK ADD  CONSTRAINT [FK_ReceptionGuidePack_Pack] FOREIGN KEY([PackId])
REFERENCES [dbo].[Pack] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuidePack] CHECK CONSTRAINT [FK_ReceptionGuidePack_Pack]
GO
ALTER TABLE [dbo].[ReceptionGuidePack]  WITH CHECK ADD  CONSTRAINT [FK_ReceptionGuidePack_ReceptionGuide] FOREIGN KEY([ReceptionGuideId])
REFERENCES [dbo].[ReceptionGuide] ([Id])
GO
ALTER TABLE [dbo].[ReceptionGuidePack] CHECK CONSTRAINT [FK_ReceptionGuidePack_ReceptionGuide]
GO
ALTER TABLE [dbo].[Responsible]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Responsible_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Responsible] CHECK CONSTRAINT [FK_dbo.Responsible_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Responsible]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Responsible_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Responsible] CHECK CONSTRAINT [FK_dbo.Responsible_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[RoadMap]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoadMap_dbo.RoadMapMovementsType_RoadMapoMovementTypeId] FOREIGN KEY([RoadMapMovementTypeId])
REFERENCES [dbo].[RoadMapMovementsType] ([Id])
GO
ALTER TABLE [dbo].[RoadMap] CHECK CONSTRAINT [FK_dbo.RoadMap_dbo.RoadMapMovementsType_RoadMapoMovementTypeId]
GO
ALTER TABLE [dbo].[RoadMap]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoadMap_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoadMap] CHECK CONSTRAINT [FK_dbo.RoadMap_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[RoadMap]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoadMap_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[RoadMap] CHECK CONSTRAINT [FK_dbo.RoadMap_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[RoadMapAndShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoadMapAndShippingGuide_dbo.RoadMap_RoadMapId] FOREIGN KEY([RoadMapId])
REFERENCES [dbo].[RoadMap] ([Id])
GO
ALTER TABLE [dbo].[RoadMapAndShippingGuide] CHECK CONSTRAINT [FK_dbo.RoadMapAndShippingGuide_dbo.RoadMap_RoadMapId]
GO
ALTER TABLE [dbo].[RoadMapAndShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoadMapAndShippingGuide_dbo.ShippingGuide_ShippingGuideId] FOREIGN KEY([ShippingGuideId])
REFERENCES [dbo].[ShippingGuide] ([Id])
GO
ALTER TABLE [dbo].[RoadMapAndShippingGuide] CHECK CONSTRAINT [FK_dbo.RoadMapAndShippingGuide_dbo.ShippingGuide_ShippingGuideId]
GO
ALTER TABLE [dbo].[RoadMapAndShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_RoadMapAndShippingGuide_RoadMapMovementsType] FOREIGN KEY([RoadMapMovementTypeId])
REFERENCES [dbo].[RoadMapMovementsType] ([Id])
GO
ALTER TABLE [dbo].[RoadMapAndShippingGuide] CHECK CONSTRAINT [FK_RoadMapAndShippingGuide_RoadMapMovementsType]
GO
ALTER TABLE [dbo].[Role]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Role_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Role] CHECK CONSTRAINT [FK_dbo.Role_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Role]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Role_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Role] CHECK CONSTRAINT [FK_dbo.Role_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Sector]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Sector_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Sector] CHECK CONSTRAINT [FK_dbo.Sector_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Sector]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Sector_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Sector] CHECK CONSTRAINT [FK_dbo.Sector_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[Shift]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Shift_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Shift] CHECK CONSTRAINT [FK_dbo.Shift_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Shift]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Shift_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Shift] CHECK CONSTRAINT [FK_dbo.Shift_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[ShippingAndReception]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ShippingAndReception_dbo.ReceptionGuide_ReceptionGuideId] FOREIGN KEY([ReceptionGuideId])
REFERENCES [dbo].[ReceptionGuide] ([Id])
GO
ALTER TABLE [dbo].[ShippingAndReception] CHECK CONSTRAINT [FK_dbo.ShippingAndReception_dbo.ReceptionGuide_ReceptionGuideId]
GO
ALTER TABLE [dbo].[ShippingAndReception]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ShippingAndReception_dbo.ShippingGuide_ShippingGuideId] FOREIGN KEY([ShippingGuideId])
REFERENCES [dbo].[ShippingGuide] ([Id])
GO
ALTER TABLE [dbo].[ShippingAndReception] CHECK CONSTRAINT [FK_dbo.ShippingAndReception_dbo.ShippingGuide_ShippingGuideId]
GO
ALTER TABLE [dbo].[ShippingContainer]  WITH CHECK ADD  CONSTRAINT [FK_ShippingContainer_ContainerLocation] FOREIGN KEY([ContainerLocationId])
REFERENCES [dbo].[ContainerLocation] ([Id])
GO
ALTER TABLE [dbo].[ShippingContainer] CHECK CONSTRAINT [FK_ShippingContainer_ContainerLocation]
GO
ALTER TABLE [dbo].[ShippingContainer]  WITH CHECK ADD  CONSTRAINT [FK_ShippingContainer_ShippingPackage] FOREIGN KEY([ShippingPackageId])
REFERENCES [dbo].[ShippingPackage] ([Id])
GO
ALTER TABLE [dbo].[ShippingContainer] CHECK CONSTRAINT [FK_ShippingContainer_ShippingPackage]
GO
ALTER TABLE [dbo].[ShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ShippingGuide_dbo.Location_LocationDestinationId] FOREIGN KEY([LocationDestinationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuide] CHECK CONSTRAINT [FK_dbo.ShippingGuide_dbo.Location_LocationDestinationId]
GO
ALTER TABLE [dbo].[ShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ShippingGuide_dbo.Location_LocationOriginId] FOREIGN KEY([LocationOriginId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuide] CHECK CONSTRAINT [FK_dbo.ShippingGuide_dbo.Location_LocationOriginId]
GO
ALTER TABLE [dbo].[ShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ShippingGuide_dbo.ShippingGuideMovementsType_ShippingGuideMovementTypeId] FOREIGN KEY([ShippingGuideMovementTypeId])
REFERENCES [dbo].[ShippingGuideMovementsType] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuide] CHECK CONSTRAINT [FK_dbo.ShippingGuide_dbo.ShippingGuideMovementsType_ShippingGuideMovementTypeId]
GO
ALTER TABLE [dbo].[ShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ShippingGuide_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShippingGuide] CHECK CONSTRAINT [FK_dbo.ShippingGuide_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[ShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ShippingGuide_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuide] CHECK CONSTRAINT [FK_dbo.ShippingGuide_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[ShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_ShippingGuide_OrderSheet] FOREIGN KEY([OrderSheetId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuide] CHECK CONSTRAINT [FK_ShippingGuide_OrderSheet]
GO
ALTER TABLE [dbo].[ShippingGuide]  WITH CHECK ADD  CONSTRAINT [FK_ShippingGuide_ShippingGuideStatus] FOREIGN KEY([ShippingGuideStatusId])
REFERENCES [dbo].[ShippingGuideStatus] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuide] CHECK CONSTRAINT [FK_ShippingGuide_ShippingGuideStatus]
GO
ALTER TABLE [dbo].[ShippingGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideDetail] CHECK CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.Article_ArticleId]
GO
ALTER TABLE [dbo].[ShippingGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.Item_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideDetail] CHECK CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.Item_ItemId]
GO
ALTER TABLE [dbo].[ShippingGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideDetail] CHECK CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.Model_ModelId]
GO
ALTER TABLE [dbo].[ShippingGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.PackageDetail_PackageDetailId] FOREIGN KEY([PackageDetailId])
REFERENCES [dbo].[PackageDetail] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideDetail] CHECK CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.PackageDetail_PackageDetailId]
GO
ALTER TABLE [dbo].[ShippingGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.ShippingGuide_ShippingGuideId] FOREIGN KEY([ShippingGuideId])
REFERENCES [dbo].[ShippingGuide] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideDetail] CHECK CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.ShippingGuide_ShippingGuideId]
GO
ALTER TABLE [dbo].[ShippingGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShippingGuideDetail] CHECK CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[ShippingGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideDetail] CHECK CONSTRAINT [FK_dbo.ShippingGuideDetail_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[ShippingGuideDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ShippingGuideDetail_ShippingPackage] FOREIGN KEY([ShippingPackageId])
REFERENCES [dbo].[ShippingPackage] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideDetail] CHECK CONSTRAINT [FK_ShippingGuideDetail_ShippingPackage]
GO
ALTER TABLE [dbo].[ShippingGuideError]  WITH CHECK ADD  CONSTRAINT [FK_ShippingGuideError_ShippingGuideError] FOREIGN KEY([IdShippingGuide])
REFERENCES [dbo].[ShippingGuide] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShippingGuideError] CHECK CONSTRAINT [FK_ShippingGuideError_ShippingGuideError]
GO
ALTER TABLE [dbo].[ShippingGuideErrorDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ShippingGuideErrorDetail_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideErrorDetail] CHECK CONSTRAINT [FK_ShippingGuideErrorDetail_Item]
GO
ALTER TABLE [dbo].[ShippingGuideErrorDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ShippingGuideErrorDetail_ShippingGuide] FOREIGN KEY([IdShippingGuideOrigin])
REFERENCES [dbo].[ShippingGuide] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideErrorDetail] CHECK CONSTRAINT [FK_ShippingGuideErrorDetail_ShippingGuide]
GO
ALTER TABLE [dbo].[ShippingGuideErrorDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ShippingGuideErrorDetail_ShippingGuideError] FOREIGN KEY([IdShippingGuideError])
REFERENCES [dbo].[ShippingGuideError] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideErrorDetail] CHECK CONSTRAINT [FK_ShippingGuideErrorDetail_ShippingGuideError]
GO
ALTER TABLE [dbo].[ShippingGuideErrorDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_ShippingGuideErrorDetail_ShippingGuideTypeError] FOREIGN KEY([IdShippingGuideTypeError])
REFERENCES [dbo].[ShippingGuideTypeError] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideErrorDetail] CHECK CONSTRAINT [FK_ShippingGuideErrorDetail_ShippingGuideTypeError]
GO
ALTER TABLE [dbo].[ShippingGuideIntermediate]  WITH NOCHECK ADD  CONSTRAINT [FK_ShippingGuideIntermediate_Item] FOREIGN KEY([IdItem])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideIntermediate] CHECK CONSTRAINT [FK_ShippingGuideIntermediate_Item]
GO
ALTER TABLE [dbo].[ShippingGuideIntermediate]  WITH NOCHECK ADD  CONSTRAINT [FK_ShippingGuideIntermediate_ShippingGuideTypeError] FOREIGN KEY([ShippingGuideTypeErrorId])
REFERENCES [dbo].[ShippingGuideTypeError] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuideIntermediate] CHECK CONSTRAINT [FK_ShippingGuideIntermediate_ShippingGuideTypeError]
GO
ALTER TABLE [dbo].[ShippingGuidePack]  WITH CHECK ADD  CONSTRAINT [FK_ShippingGuidePack_Pack] FOREIGN KEY([PackId])
REFERENCES [dbo].[Pack] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuidePack] CHECK CONSTRAINT [FK_ShippingGuidePack_Pack]
GO
ALTER TABLE [dbo].[ShippingGuidePack]  WITH CHECK ADD  CONSTRAINT [FK_ShippingGuidePack_ShippingGuide] FOREIGN KEY([ShippingGuideId])
REFERENCES [dbo].[ShippingGuide] ([Id])
GO
ALTER TABLE [dbo].[ShippingGuidePack] CHECK CONSTRAINT [FK_ShippingGuidePack_ShippingGuide]
GO
ALTER TABLE [dbo].[ShippingGuideRestriction]  WITH CHECK ADD  CONSTRAINT [FK_ShippingGuideRestriction_ShippingGuideRestriction] FOREIGN KEY([Id])
REFERENCES [dbo].[ShippingGuide] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShippingGuideRestriction] CHECK CONSTRAINT [FK_ShippingGuideRestriction_ShippingGuideRestriction]
GO
ALTER TABLE [dbo].[ShippingPackage]  WITH CHECK ADD  CONSTRAINT [FK_ShippingPackage_Package] FOREIGN KEY([PackageId])
REFERENCES [dbo].[Package] ([Id])
GO
ALTER TABLE [dbo].[ShippingPackage] CHECK CONSTRAINT [FK_ShippingPackage_Package]
GO
ALTER TABLE [dbo].[ShippingPackage]  WITH CHECK ADD  CONSTRAINT [FK_ShippingPackage_UserAccount] FOREIGN KEY([UserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[ShippingPackage] CHECK CONSTRAINT [FK_ShippingPackage_UserAccount]
GO
ALTER TABLE [dbo].[StockAuditGuide]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuide_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuide] CHECK CONSTRAINT [FK_StockAuditGuide_Location]
GO
ALTER TABLE [dbo].[StockAuditGuide]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuide_OrderSheet] FOREIGN KEY([OrderSheetId])
REFERENCES [dbo].[OrderSheet] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuide] CHECK CONSTRAINT [FK_StockAuditGuide_OrderSheet]
GO
ALTER TABLE [dbo].[StockAuditGuide]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuide_UserAccount] FOREIGN KEY([UserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuide] CHECK CONSTRAINT [FK_StockAuditGuide_UserAccount]
GO
ALTER TABLE [dbo].[StockAuditGuide]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuide_UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuide] CHECK CONSTRAINT [FK_StockAuditGuide_UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[StockAuditGuide]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuide_UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuide] CHECK CONSTRAINT [FK_StockAuditGuide_UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[StockAuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuideDetail_Article_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuideDetail] CHECK CONSTRAINT [FK_StockAuditGuideDetail_Article_ArticleId]
GO
ALTER TABLE [dbo].[StockAuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuideDetail_Item_ItemId] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuideDetail] CHECK CONSTRAINT [FK_StockAuditGuideDetail_Item_ItemId]
GO
ALTER TABLE [dbo].[StockAuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuideDetail_Model_ModelId] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuideDetail] CHECK CONSTRAINT [FK_StockAuditGuideDetail_Model_ModelId]
GO
ALTER TABLE [dbo].[StockAuditGuideDetail]  WITH CHECK ADD  CONSTRAINT [FK_StockAuditGuideDetail_StockAuditGuide_AuditGuideId] FOREIGN KEY([StockAuditGuideId])
REFERENCES [dbo].[StockAuditGuide] ([Id])
GO
ALTER TABLE [dbo].[StockAuditGuideDetail] CHECK CONSTRAINT [FK_StockAuditGuideDetail_StockAuditGuide_AuditGuideId]
GO
ALTER TABLE [dbo].[StockLocation]  WITH CHECK ADD  CONSTRAINT [FK_StockLocation_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[StockLocation] CHECK CONSTRAINT [FK_StockLocation_Article]
GO
ALTER TABLE [dbo].[StockLocation]  WITH CHECK ADD  CONSTRAINT [FK_StockLocation_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[StockLocation] CHECK CONSTRAINT [FK_StockLocation_Location]
GO
ALTER TABLE [dbo].[StockLocation]  WITH CHECK ADD  CONSTRAINT [FK_StockLocation_Model] FOREIGN KEY([ModelId])
REFERENCES [dbo].[Model] ([Id])
GO
ALTER TABLE [dbo].[StockLocation] CHECK CONSTRAINT [FK_StockLocation_Model]
GO
ALTER TABLE [dbo].[Supplier]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Supplier_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Supplier] CHECK CONSTRAINT [FK_dbo.Supplier_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[Supplier]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Supplier_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[Supplier] CHECK CONSTRAINT [FK_dbo.Supplier_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[SysParam]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SysParam_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SysParam] CHECK CONSTRAINT [FK_dbo.SysParam_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[SysParam]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SysParam_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[SysParam] CHECK CONSTRAINT [FK_dbo.SysParam_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserAccount_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[UserAccount] CHECK CONSTRAINT [FK_dbo.UserAccount_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserAccount_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[UserAccount] CHECK CONSTRAINT [FK_dbo.UserAccount_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[UserAccount]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserAccount_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[UserAccount] CHECK CONSTRAINT [FK_dbo.UserAccount_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[UserAccountLocation]  WITH CHECK ADD  CONSTRAINT [FK_UserAccountLocation_Location] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([Id])
GO
ALTER TABLE [dbo].[UserAccountLocation] CHECK CONSTRAINT [FK_UserAccountLocation_Location]
GO
ALTER TABLE [dbo].[UserAccountLocation]  WITH CHECK ADD  CONSTRAINT [FK_UserAccountLocation_UserAccount] FOREIGN KEY([UserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[UserAccountLocation] CHECK CONSTRAINT [FK_UserAccountLocation_UserAccount]
GO
ALTER TABLE [dbo].[UserAccountRole]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserAccountRole_dbo.Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO
ALTER TABLE [dbo].[UserAccountRole] CHECK CONSTRAINT [FK_dbo.UserAccountRole_dbo.Role_RoleId]
GO
ALTER TABLE [dbo].[UserAccountRole]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserAccountRole_dbo.UserAccount_CreationUserAccountId] FOREIGN KEY([CreationUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[UserAccountRole] CHECK CONSTRAINT [FK_dbo.UserAccountRole_dbo.UserAccount_CreationUserAccountId]
GO
ALTER TABLE [dbo].[UserAccountRole]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserAccountRole_dbo.UserAccount_ModifiedUserAccountId] FOREIGN KEY([ModifiedUserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
GO
ALTER TABLE [dbo].[UserAccountRole] CHECK CONSTRAINT [FK_dbo.UserAccountRole_dbo.UserAccount_ModifiedUserAccountId]
GO
ALTER TABLE [dbo].[UserAccountRole]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserAccountRole_dbo.UserAccount_UserAccountId] FOREIGN KEY([UserAccountId])
REFERENCES [dbo].[UserAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserAccountRole] CHECK CONSTRAINT [FK_dbo.UserAccountRole_dbo.UserAccount_UserAccountId]
GO
ALTER TABLE [dbo].[ValidationRead]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ValidationRead_dbo.ValidationRead_Article] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Article] ([Id])
GO
ALTER TABLE [dbo].[ValidationRead] CHECK CONSTRAINT [FK_dbo.ValidationRead_dbo.ValidationRead_Article]
GO
ALTER TABLE [dbo].[ValidationRead]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ValidationRead_dbo.ValidationRead_Checkpoint] FOREIGN KEY([CheckpointId])
REFERENCES [dbo].[CheckPoint] ([Id])
GO
ALTER TABLE [dbo].[ValidationRead] CHECK CONSTRAINT [FK_dbo.ValidationRead_dbo.ValidationRead_Checkpoint]
GO
ALTER TABLE [dbo].[ValidationRead]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ValidationRead_dbo.ValidationRead_Item] FOREIGN KEY([ItemId])
REFERENCES [dbo].[Item] ([Id])
GO
ALTER TABLE [dbo].[ValidationRead] CHECK CONSTRAINT [FK_dbo.ValidationRead_dbo.ValidationRead_Item]
GO
/****** Object:  StoredProcedure [dbo].[assetsMovementsHeader_getReport]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[assetsMovementsHeader_getReport]
(
    @fromDate datetime
  , @toDate datetime
  , @sourceLocationIds varchar(8000)
  , @destinationLocationIds varchar(8000)
  , @assetMovementTypeIds varchar(8000)
  , @shippingNumber nvarchar(40)
  , @receptionNumber nvarchar(40)
  , @permissionRequired bit
  , @pageNumber int
  , @pageSize int
  , @totalRowCount int output
)
with recompile
as
begin
  declare @rc int
  declare @sDelimiter varchar(1) 

  set @sDelimiter = ','

  set nocount on;
   
  -- Trae los tipos de movimientos.
  if object_id('tempdb..#assetsMovementTypes') is not null
    drop table #assetsMovementTypes

  create table #assetsMovementTypes
  (
    assetMovementTypeId int
  )

  insert into #assetsMovementTypes
  select item 
    from [dbo].[fnSplit] (@assetMovementTypeIds, @sDelimiter)


  -- Calcula las ubicaciones hijas de las ubicaci髇 en el origen.
  if object_id('tempdb..#sourceLocations') is not null
    drop table #sourceLocations

  create table #sourceLocations
  (
    locationId int
  )

  insert into #sourceLocations
  select item 
    from [dbo].[fnSplit] (@sourceLocationIds, @sDelimiter)

  insert into #sourceLocations
  select l.id
    from [dbo].[Location] l
    inner join #sourceLocations sl on l.parentId = sl.locationId
    left join #sourceLocations sl2 on l.id = sl2.locationId
  where sl2.locationId is null

  -- Calcula las ubicaciones hijas de las ubicaci髇 en el destino.
  if object_id('tempdb..#destinationLocations') is not null
    drop table #destinationLocations

  create table #destinationLocations
  (
    locationId int
  )

  insert into #destinationLocations
  select item 
    from [dbo].[fnSplit] (@destinationLocationIds, @sDelimiter)

  insert into #destinationLocations
  select l.id
    from [dbo].[Location] l
    inner join #destinationLocations dl on l.parentId = dl.locationId
    left join #destinationLocations dl2 on l.id = dl2.locationId
  where dl2.locationId is null

  -- 0. Filtra los movimientos
  if object_id('tempdb..#amhsr') is not null
    drop table #amhsr

  create table #amhsr
  (
      assetsMovementsHeaderId int not null 
    , creationDate datetime not null
    , sourceLocation nvarchar(255) not null
    , targetLocation nvarchar(255) not null
    , permissionRequired bit not null
    , assetsMovementsType nvarchar(255) not null
    , shippingGuideId int null
    , receptionGuideId int null
    , deliveryGuideId int null
    , primary key(assetsMovementsHeaderId)
  )

  insert into #amhsr
  select distinct amh.id assetsMovementsHeaderId
        , amh.creationDate
        , sl.Name sourceLocation
        , dl.Name targetLocation
        , amh.permissionRequired
        , amt.description [assetsMovementsType]
        , sg.id shippingGuideId
        , rg.id receptionGuideId
        , dg.id deliveryGuideId
    from [AssetsMovementsHeader] amh
    inner join [AssetsMovementsType] amt on amh.AssetMovementTypeId = amt.id
    inner join [Location] sl on amh.SourceLocationId = sl.id
    inner join [Location] dl on amh.DestinationLocationId = dl.id
    left join [ShippingGuide] sg on amh.ShippingGuideId = sg.id
    left join [ReceptionGuide] rg on amh.ReceptionGuideId = rg.id
    left join [DeliveryGuide] dg on amh.DeliveryGuideId = dg.id
    left join [ShippingAndReception] sar on rg.id = sar.ReceptionGuideId
    left join [ShippingGuide] sg2 on sar.ShippingGuideId = sg2.id
  where 
	(
		sl.id in 
		(
		  select locationId
		    from #sourceLocations
		)
		or
		sg2.LocationOriginId in 
		(
		  select locationId
		    from #sourceLocations
		)
	)
    and (
          @destinationLocationIds is null 
          or 
          dl.id in 
          (
            select locationId
              from #destinationLocations
          )
        )
    and (
          @assetMovementTypeIds is null 
          or 
          amt.id in 
          (
            select assetMovementTypeId
              from #assetsMovementTypes
          )
        )
    and (
            @shippingNumber is null 
            or (sg.ShippingNumber is not null and sg.ShippingNumber = @shippingNumber) 
            or (sg2.ShippingNumber is not null and sg2.ShippingNumber = @shippingNumber)
        )
    and (
            @receptionNumber is null 
            or (rg.ReceptionNumber is not null and rg.ReceptionNumber = @receptionNumber)
        )
    and amh.CreationDate between  @fromDate and @toDate


  --  1. Cacula los remitos de las Gu韆s de Traspaso
  -- (Puede haber mas de una gu韆 de traspaso para una gu韆 de recepci髇)
  if object_id('tempdb..#srn') is not null
    drop table #srn

  create table #srn
  (
      receptionGuideId int
    , shippingNumber nvarchar(255)
  )

  create index srnIX1 on #srn (receptionGuideId)

  insert into #srn
  select  rg.id [receptionGuideId]
        , isnull(sg.ShippingNumber, sg2.ShippingNumber) [shippingNumber]
    from #amhsr amh
    left join [ShippingGuide] sg on amh.ShippingGuideId = sg.id
    left join [ReceptionGuide] rg on amh.ReceptionGuideId = rg.id
    left join [ShippingAndReception] sar on rg.id = sar.ReceptionGuideId
    left join [ShippingGuide] sg2 on sar.ShippingGuideId = sg2.id

  if object_id('tempdb..#shippingReceptionNumbers') is not null
    drop table #shippingReceptionNumbers

  create table #shippingReceptionNumbers
  (
      receptionGuideId int
    , shippingNumber nvarchar(255)
  )

  create index shippingReceptionNumbersIX1 on #shippingReceptionNumbers (receptionGuideId)

  insert into #shippingReceptionNumbers
  select  p1.receptionGuideId
        , ( 
            select shippingNumber + ' - ' 
              from #srn p2
            where p2.receptionGuideId = p1.receptionGuideId
            order by shippingNumber
            for xml path('')
          ) as shippingNumbers
    from #srn p1
  group by receptionGuideId


   if object_id('tempdb..#receptionGuideOrigin') is not null
    drop table #receptionGuideOrigin

  create table #receptionGuideOrigin
  (
      receptionGuideId int
    , locationOrigin varchar(255)
  )

  insert into #receptionGuideOrigin
  select distinct amhsr.receptionGuideId, 
	(select distinct l.Name + ','
  from Location l 
  inner join ShippingGuide sg2 on l.Id = sg2.LocationOriginId
  inner join ShippingAndReception sar2 on sg2.Id = sar2.ShippingGuideId
  inner join AssetsMovementsHeader amh2 on amh2.ReceptionGuideId = sar2.ReceptionGuideId
  where amh2.Id = amhsr.assetsMovementsHeaderId
  for xml path(''))
  from ShippingAndReception sar
  inner join #amhsr amhsr on amhsr.receptionGuideId = sar.ReceptionGuideId


  --  2. Calcula la descripci髇 del Articulo
  if object_id('tempdb..#amhArtCompleteDescription') is not null
    drop table #amhArtCompleteDescription

  create table #amhArtCompleteDescription
  (
      model nvarchar(255) not null
	, modelId int not null
    , articleId int not null
    , articleCompleteDescription nvarchar(255) not null
  )

  create index amhArtCompleteDescriptionIX1 on #amhArtCompleteDescription (articleId)

  -- Solo de movimientos no manuales.
  insert into #amhArtCompleteDescription
  select  distinct
          m.description model
		, m.Id modelId
        , a.id articleId
        , a.codArt + ' - ' + m.description + ' - ' + b.code +
          case 
            when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
            when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
            when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
            when (ca.Generic = 1 and s.Generic = 1) then ''
          end [articleCompleteDescription]
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    inner join [AssetsMovementsItemsDetail] amid on ami.id = amid.AssetsMovementsItemId
    inner join [Article] a on amid.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
    inner join [Brand] b on a.brandId = b.id
    inner join [ColorArt] ca on a.ColorArtId = ca.id
    inner join [Size] s on a.SizeId = s.id
  where amh.[assetsMovementsType] not like '%Manual%'

  -- Solo de movimientos no manuales con carga manual de prendas.
  insert into #amhArtCompleteDescription
  select  distinct
          m.description model
		, m.Id modelId
        , a.id articleId
        , a.codArt + ' - ' + m.description + ' - ' + b.code +
          case 
            when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
            when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
            when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
            when (ca.Generic = 1 and s.Generic = 1) then ''
          end [articleCompleteDescription]
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    left join [AssetsMovementsItemsDetail] amid on ami.id = amid.AssetsMovementsItemId
    inner join [Article] a on ami.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
    inner join [Brand] b on a.brandId = b.id
    inner join [ColorArt] ca on a.ColorArtId = ca.id
    inner join [Size] s on a.SizeId = s.id
    left join #amhArtCompleteDescription amhacd on a.id = amhacd.articleId
  where amh.[assetsMovementsType] not like '%Manual%'
    and amhacd.articleId is null
    and amid.id is null

  --  Solo de movimientos manuales.
  insert into #amhArtCompleteDescription
  select  distinct
          m.description model
		, m.Id modelId
        , a.id articleId
        , a.codArt + ' - ' + m.description + ' - ' + b.code +
          case 
            when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
            when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
            when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
            when (ca.Generic = 1 and s.Generic = 1) then ''
          end [articleCompleteDescription]
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    inner join [Article] a on ami.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
    inner join [Brand] b on a.brandId = b.id
    inner join [ColorArt] ca on a.ColorArtId = ca.id
    inner join [Size] s on a.SizeId = s.id
    left join #amhArtCompleteDescription amhacd on a.id = amhacd.articleId
  where amh.[assetsMovementsType] like '%Manual%'
    and amhacd.articleId is null


  --  3. Calcula las cantidades
  if object_id('tempdb..#amhQty') is not null
    drop table #amhQty

  create table #amhQty
  (
      assetsMovementHeaderId int not null
    , articleId int not null
    , modelId int not null
    , categoryId int 
    , itemsPerPackage int
    , packageQuantity int
    , articleQuantity int
  )

  create index amhQtyIX1 on #amhQty (assetsMovementHeaderId)

  -- Solo de movimientos no manuales.
  insert into #amhQty
  select  ami.assetsMovementHeaderId
        , amid.articleId
        , m.Id
        , m.CategoryId
        , m.itemsPerPackage
        , isnull(ami.packageQuantity, '') packageQuantity
        , count(amid.id) articleQuantity
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    inner join [AssetsMovementsItemsDetail] amid on ami.id = amid.AssetsMovementsItemId
    inner join [Article] a on amid.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
  where amh.[assetsMovementsType] not like '%Manual%'
  group by  ami.AssetsMovementHeaderId
          , amid.articleId
          , m.Id
          , m.CategoryId
          , m.itemsPerPackage
          , ami.packageQuantity

  -- Se recalcula la cantidad de bultos a partir de la cantidad de prendas de cada art韈ulo.
  update amhQty
    set amhQty.packageQuantity = (amhQty.articleQuantity / amhQty.itemsPerPackage)
  from #amhQty amhQty
  where amhQty.packageQuantity is not null

  -- Solo de movimientos no manuales con carga manual de prendas.
  insert into #amhQty
  select  ami.assetsMovementHeaderId
        , ami.articleId
        , m.Id
        , null
        , m.itemsPerPackage
        , isnull(ami.packageQuantity, '') packageQuantity
        , sum(ami.Quantity) articleQuantity
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    left join [AssetsMovementsItemsDetail] amid on ami.id = amid.AssetsMovementsItemId
    left join [Article] a on ami.ArticleId = a.id
    left join [Model] m on a.modelId = m.id
  where amh.[assetsMovementsType] not like '%Manual%'
    and amid.id is null
  group by  ami.AssetsMovementHeaderId
          , ami.articleId
          , m.Id
          , m.itemsPerPackage
          , ami.packageQuantity

  -- Solo de movimientos manuales.
  insert into #amhQty
  select  ami.assetsMovementHeaderId
        , ami.articleId
        , m.Id
        , m.CategoryId
        , m.itemsPerPackage
        , isnull(ami.packageQuantity, '') packageQuantity
        , sum(ami.Quantity) articleQuantity
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    inner join [Article] a on ami.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
  where amh.[assetsMovementsType] like '%Manual%'
  group by  ami.AssetsMovementHeaderId
          , ami.articleId
          , m.Id
          , m.CategoryId
          , m.itemsPerPackage
          , ami.packageQuantity


  -- 5. Calcula las autorizaciones de las gu韆s de traspaso, traspaso a lavadero e interna.
  -- WARNING: SG/SGA 19/02/2019. No se estan contabilizando la cantidad de autorizaciones realizadas ni la cantidad de autorizaciones por usuario.
  -- Para ver ese destalle se debe usar el reporte "Autorizaciones". 
  if object_id('tempdb..#sgalog') is not null
    drop table #sgalog

  create table #sgalog
  (
      shippingGuideId int
    , authorizationUserName nvarchar(255)
    , authorizationDescription nvarchar(255)
  )

  create index sgalogIX1 on #sgalog (shippingGuideId)

  insert into #sgalog
  select  distinct
          amh.ShippingGuideId [shippingGuideId]
        , ua.UserName [authorizationUserName]
        , sf.Description [authorizationDescription]
    from #amhsr amh
    left join [AuthorizationLog] al on amh.ShippingGuideId = al.ShippingGuideId
    left join [SysFunction] sf on al.SysFunctionId = sf.id
    left join [UserAccount] ua on al.CreationUserAccountId = ua.id

  if object_id('tempdb..#shippingGuideAuthorization') is not null
    drop table #shippingGuideAuthorization

  create table #shippingGuideAuthorization
  (
      shippingGuideId int
    , authorizationUserName nvarchar(255)
    , authorizationDescription nvarchar(255)
  )

  create index shippingGuideAuthorizationIX1 on #shippingGuideAuthorization (shippingGuideId)

  insert into #shippingGuideAuthorization
  select  p1.shippingGuideId
        , (
            select distinct p2.authorizationUserName + ' - ' 
              from #sgalog p2
            where p2.shippingGuideId = p1.shippingGuideId
            order by p2.authorizationUserName + ' - '
            for xml path('')
          ) as authorizationUserNames
        , (
            select distinct p2.authorizationDescription + ' - ' 
              from #sgalog p2
            where p2.shippingGuideId = p1.shippingGuideId
            order by p2.authorizationDescription + ' - '
            for xml path('')
          ) as authorizationDescriptions
    from #sgalog p1
  group by shippingGuideId


  -- 6. Calcula las autorizaciones de las gu韆s de recepci髇, recepci髇 en lavadero.
  -- WARNING: SG/SGA 19/02/2019. Dado el contexto de uso actual, no se contempla m鷏tiples usuarios autorizando en las gu韆s de recepci髇. 

  if object_id('tempdb..#rgalog') is not null
    drop table #rgalog

  create table #rgalog
  (
      receptionGuideId int
    , userAccountId int
    , authorizationDescription nvarchar(255)
  )

  create index rgalogIX1 on #rgalog (receptionGuideId)

  insert into #rgalog
  select  distinct
          amh.ReceptionGuideId [receptionGuideId]
        , al.CreationUserAccountId [UserAccountId]
        , sf.Description [authorizationDescription]
    from #amhsr amh
    left join [AuthorizationLog] al on amh.ReceptionGuideId = al.ReceptionGuideId
    left join [SysFunction] sf on al.SysFunctionId = sf.id

  if object_id('tempdb..#receptionGuideAuthorization') is not null
    drop table #receptionGuideAuthorization

  create table #receptionGuideAuthorization
  (
      receptionGuideId int
    , userAccountId int
    , authorizationDescription nvarchar(255)
  )

  create index receptionGuideAuthorizationIX1 on #receptionGuideAuthorization (receptionGuideId)

  insert into #receptionGuideAuthorization
  select  p1.receptionGuideId
        , p1.userAccountId
        , ( 
            select authorizationDescription + ' - ' 
              from #rgalog p2
            where p2.receptionGuideId = p1.receptionGuideId
            order by authorizationDescription
            for xml path('')
          ) as receptionGuideAuthorization
    from #rgalog p1
  group by receptionGuideId, userAccountId


  -- 7. Calcula las autorizaciones de las entrega de prendas.
  -- WARNING: SG/SGA 19/02/2019. Dado el contexto de uso actual, no se contempla m鷏tiples usuarios autorizando en el m骴ulo entrega de prendas. 
  if object_id('tempdb..#dgalog') is not null
    drop table #dgalog

  create table #dgalog
  (
      deliveryGuideId int
    , userAccountId int
    , authorizationDescription nvarchar(255)
  )

  create index dgalogIX1 on #dgalog (deliveryGuideId)

  insert into #dgalog
  select  distinct
          amh.DeliveryGuideId [deliveryGuideId]
        , al.CreationUserAccountId [UserAccountId]
        , sf.Description [authorizationDescription]
    from #amhsr amh
    left join [AuthorizationLog] al on amh.DeliveryGuideId = al.DeliveryGuideId
    left join [SysFunction] sf on al.SysFunctionId = sf.id

  if object_id('tempdb..#deliveryGuideAuthorization') is not null
    drop table #deliveryGuideAuthorization

  create table #deliveryGuideAuthorization
  (
      deliveryGuideId int
    , userAccountId int
    , authorizationDescription nvarchar(255)
  )

  create index deliveryGuideAuthorizationIX1 on #deliveryGuideAuthorization (deliveryGuideId)

  insert into #deliveryGuideAuthorization
  select  p1.deliveryGuideId
        , p1.userAccountId
        , ( 
            select authorizationDescription + ' - ' 
              from #dgalog p2
            where p2.deliveryGuideId = p1.deliveryGuideId
            order by authorizationDescription
            for xml path('')
          ) as deliveryGuideAuthorization
    from #dgalog p1
  group by deliveryGuideId, userAccountId
  

  -- 8. Obtiene los ModelId de prendas sugeridas cuyo articulo fue leido
  declare @grupingCategories varchar(100)
  select @grupingCategories = (select Value from SysParam where Name = 'GroupingCategories') 
  if object_id('tempdb..#orderedModelsRead') is not null
    drop table #orderedModelsRead

  create table #orderedModelsRead
  (
	shippingGuideId int,
    modelId int
  )

  if object_id('tempdb..#orderedArticlesReadInShippingGuide') is not null
    drop table #orderedArticlesReadInShippingGuide

  create table #orderedArticlesReadInShippingGuide
  (
    articleId int,
	shippingGuideId int,
	orderSheetId int
  )

  insert into #orderedArticlesReadInShippingGuide
  select distinct sgd.ArticleId, sgd.ShippingGuideId, sg.OrderSheetId from #amhsr amh
  inner join ShippingGuide sg on amh.shippingGuideId = sg.Id
  inner join ShippingGuideDetail sgd on sg.Id = sgd.ShippingGuideId

  insert into #orderedModelsRead
  select art.shippingGuideId, osi.ModelId
  from #orderedArticlesReadInShippingGuide art
  inner join OrderSheet os on art.orderSheetId = os.Id
  inner join OrderSheetItem osi on osi.OrderSheetId = os.Id and osi.ArticleId = art.articleId


  declare @sendPendingMovementTypeId varchar(50)
  select @sendPendingMovementTypeId = (select Description from AssetsMovementsType where Id = 30)

  	if object_id('tempdb..#univocalItems') is not null
		drop table #univocalItems

	create table #univocalItems
	(
		ModelId int,
		Qty int,
		OrderSheetId int
	)

	insert into #univocalItems
	select distinct osi.ModelId, osi.OrderedQuantity, osi.OrderSheetId
	from OrderSheetItem osi
	inner join OrderSheet os on osi.OrderSheetId = os.Id
	inner join ShippingGuide sg on os.Id = sg.OrderSheetId
	inner join #amhsr amh on sg.Id = amh.shippingGuideId
	inner join Model m on osi.ModelId = m.Id
	left join Category c on m.CategoryId = c.Id
	where c.Id is not null and @grupingCategories like c.Code and amh.assetsMovementsType = @sendPendingMovementTypeId


	if object_id('tempdb..#packageDetailsInOrderSheet') is not null
		drop table #packageDetailsInOrderSheet

	create table #packageDetailsInOrderSheet
	(
		packageDetailId int,
		modelId int,
		qty int,
		defaultForModel bit,
		packageId int,
		orderSheetId int
	)

	insert into #packageDetailsInOrderSheet
	select pd2.Id, pd2.ModelId, pd2.Quantity, pd2.DefaultForModel, pd2.PackageId, ui.OrderSheetId
	from PackageDetail pd 
	inner join #univocalItems ui on ui.ModelId = pd.ModelId
	inner join Model m on m.Id = pd.ModelId
	left join Category c on m.CategoryId = c.Id
	inner join Package p on pd.PackageId = p.Id
	inner join PackageDetail pd2 on p.Id = pd2.PackageId
	where c.Id is not null and @grupingCategories like c.Code and pd2.DefaultForModel = 0


	if object_id('tempdb..#orderedQtyForPacks') is not null
		drop table #orderedQtyForPacks

	create table #orderedQtyForPacks
	(
		UnivocalItemPackageDetailId int,
		UnivocalItemModelId int,
		DummyItemModelId int,
		Qty int,
		OrderSheetId int
	)

	insert into #orderedQtyForPacks
	select T.UnivocalItemPackageDetailId, T.UnivocalItemModelId, T.ModelId, (T.Quantity * sum(ui.Qty)),T.OrderSheetId
	from (select distinct pd1.Id as UnivocalItemPackageDetailId, pd1.ModelId as UnivocalItemModelId, pd.modelId as ModelId, pd.qty as Quantity,pd.orderSheetId as OrderSheetId
	from #packageDetailsInOrderSheet pd
	inner join Package p1 on pd.packageId = p1.Id
	inner join PackageDetail pd1 on p1.Id = pd1.PackageId 
	inner join Model m1 on pd1.ModelId = m1.Id
	left join Category c1 on m1.CategoryId = c1.Id
	where @grupingCategories like c1.Code and c1.Id is not null
	group by  pd1.Id, pd1.ModelId, pd.modelId, pd.qty, pd.orderSheetId) as T
	inner join #univocalItems ui on ui.ModelId = T.UnivocalItemModelId
	where T.UnivocalItemModelId != T.ModelId
	group by T.UnivocalItemPackageDetailId, T.UnivocalItemModelId, T.ModelId, t.Quantity,T.OrderSheetId


  -- 9. Consolida toda la informaci髇.
  if object_id('tempdb..#amhReport') is not null
    drop table #amhReport

  create table #amhReport
  (
      [rowNumber] int not null
    , [Date] varchar(20) not null
    , [LocationOrigin] nvarchar(255)
    , [LocationDestination] nvarchar(255)
    , [Authorize] nvarchar(255)
    , [ShippingGuide] nvarchar(255)
    , [ReceptionGuide] nvarchar(255)
    , [ModelType] nvarchar(255)
    , [ArticleName] nvarchar(255)
    , [OrderedQuantity] int
    , [QuantityArticle] int
    , [PackageQuantity] int
    , [MovementType] nvarchar(255)
    , [AuthorizationType] nvarchar(255)
    , [AuthorizationUser] nvarchar(255)
  )

  create index amhReportIX1 on #amhReport ([rowNumber])


  insert into #amhReport
  select  ROW_NUMBER() over (order by amh.creationDate asc) [RowNumber]
        , convert(varchar, amh.creationDate, 103) + ' ' + convert(varchar, amh.creationDate, 108) [Date]
        , case
			when rgo.locationOrigin is not null then rgo.locationOrigin 
			else amh.sourceLocation
			end [LocationOrigin]
        , amh.targetLocation [LocationDestination]
        , case amh.PermissionRequired when 0 then 'No ' else '' end + 'Requirio Autorizaci髇' [Authorize]
        -- 29/01/2019 JC. Para concatenar los n鷐eros de Gu韆s de Traspaso se utiliza la funcion COALESCE, ya que ISNULL 
        -- modifica la longitud de la segunda expresi髇. Fuente: https://stackoverflow.com/questions/39544764/truncation-issue-with-isnull-function-in-sql-server -
        -- Se establece la colecci髇 de ambas expresiones para evitar conflictos.
        , coalesce(sg.ShippingNumber collate SQL_Latin1_General_CP1_CI_AS, srn.ShippingNumber collate SQL_Latin1_General_CP1_CI_AS) [ShippingGuide]
        , isnull(rg.ReceptionNumber, '') [ReceptionGuide]
        , amhacd.model [ModelType]
        , amhacd.articleCompleteDescription [ArticleName]
        , (isnull(osi.OrderedQuantity, 0) + isnull(osiForIntegratedItems.OrderedQty, 0) + isnull(oq.Qty, 0)) [OrderedQuantity]
        , amhQty.articleQuantity [QuantityArticle]
        , amhQty.packageQuantity [PackageQuantity]
        , amh.assetsMovementsType [MovementType]
        , case 
            when sga.authorizationDescription is not null then sga.authorizationDescription
            when rga.authorizationDescription is not null then rga.authorizationDescription
            when dga.authorizationDescription is not null then dga.authorizationDescription
            else ''
          end [AuthorizationType]
        , case 
            when sga.authorizationUserName is not null then sga.authorizationUserName
            when rgaua.UserName is not null then rgaua.UserName
            when dgaua.UserName is not null then dgaua.UserName
            else ''
          end [AuthorizationUser]
    from #amhsr amh
    left join [ShippingGuide] sg on amh.ShippingGuideId = sg.id
    left join [ReceptionGuide] rg on amh.ReceptionGuideId = rg.id
	left join #receptionGuideOrigin rgo on rgo.receptionGuideId = rg.Id
    left join #shippingReceptionNumbers srn on rg.id = srn.receptionGuideId
    inner join #amhQty amhQty on amh.assetsMovementsHeaderId = amhQty.AssetsMovementHeaderId
    inner join #amhArtCompleteDescription amhacd on amhQty.articleId = amhacd.articleId
    left join #shippingGuideAuthorization sga on amh.ShippingGuideId = sga.shippingGuideId
    left join #receptionGuideAuthorization rga on amh.ReceptionGuideId = rga.receptionGuideId
    left join #deliveryGuideAuthorization dga on amh.DeliveryGuideId = dga.deliveryGuideId
    left join [UserAccount] rgaua on rga.[UserAccountId] = rgaua.Id
    left join [UserAccount] dgaua on dga.[UserAccountId] = dgaua.Id
    left join [OrderSheetItem] osi on sg.OrdersheetId = osi.OrdersheetId 
                                  and amhQty.articleId = osi.ArticleId
	left join (select ordQ.DummyItemModelId,ordQ.OrderSheetId, sum(ordQ.Qty) as Qty
				from #orderedQtyForPacks ordQ group by ordQ.OrderSheetId,ordQ.DummyItemModelId) oq
				on oq.DummyItemModelId = amhQty.modelId and sg.OrderSheetId is not null and sg.OrderSheetId = oq.OrderSheetId
				and amhQty.articleId = (select top 1 amhqty2.articleId from #amhQty amhqty2 
						inner join Article a on amhqty2.articleId = a.Id
						where amhqty2.modelId = amhQty.modelId
						order by a.CodArt asc)
	left join (select SUM(OrderedQuantity) as OrderedQty,OrderSheetId 
			 from OrderSheetItem osi
			 inner join Model m on osi.ModelId = m.Id
			 where m.IsPrimary = 1
			 group by osi.ModelId, osi.OrderSheetId) osiForIntegratedItems 
			 on amhQty.articleId = (select top 1 t1.articleId 
									from #amhQty t1 
									inner join Article t2 on t1.articleId = t2.Id and t2.ModelId = amhacd.modelId
									inner join Model m on t1.modelId = m.Id
									where m.IsSecondary = 1 and t1.assetsMovementHeaderId = amh.assetsMovementsHeaderId
									order by t2.CodArt asc)
			 and osiForIntegratedItems.OrderSheetId = sg.OrdersheetId
			 and exists (select ordmod.modelId 
						from #orderedModelsRead ordmod 
						inner join Model m on ordmod.modelId = m.Id
						where ordmod.shippingGuideId = amh.shippingGuideId and m.IsPrimary = 1 and m.CategoryId = amhQty.categoryId)
  
  --JC - WARNING - 20/12/2019 - Para los AMBO PANTALON se establece como cantidad pedida la suma de la cantidad pedida de AMBO CHAQUETA.
  -- Esta cantidad pedida se va a ver s髄o en el primer art韈ulo de pantalon, ordenado por codigo

    select @totalRowCount = @@ROWCOUNT

  -- Aplica paginaci髇 sobre el resultado obtenido.
  select  p.[RowNumber]
        , p.[Date]
        , p.[LocationOrigin]
        , p.[LocationDestination]
        , p.[Authorize]
        , p.[ShippingGuide]
        , p.[ReceptionGuide]
        , p.[ModelType]
        , p.[ArticleName]
        , p.[OrderedQuantity]
        , p.[QuantityArticle]
        , p.[PackageQuantity]
        , p.[MovementType]
        , p.[AuthorizationType]
        , p.[AuthorizationUser]
    from #amhReport p
  where p.[rowNumber] BETWEEN ((@pageNumber - 1) * @pageSize + 1) AND (@pageNumber * @pageSize)

  set @rc = @@error

  set nocount off;

  return @rc
  
end--procedure
GO
/****** Object:  StoredProcedure [dbo].[assetsMovementsHeader_getReport_v2017]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[assetsMovementsHeader_getReport_v2017]
(
    @fromDate datetime
  , @toDate datetime
  , @sourceLocationIds varchar(8000)
  , @destinationLocationIds varchar(8000)
  , @assetMovementTypeIds varchar(8000)
  , @shippingNumber nvarchar(40)
  , @receptionNumber nvarchar(40)
  , @permissionRequired bit
  , @pageNumber int
  , @pageSize int
  , @totalRowCount int output
)
with recompile
as
begin
  declare @rc int
  declare @sDelimiter varchar(1) 

  set @sDelimiter = ','

  set nocount on;
   
   -- Trae los tipos de movimientos.
  if object_id('tempdb..#assetsMovementTypes') is not null
    drop table #assetsMovementTypes

  create table #assetsMovementTypes
  (
    assetMovementTypeId int
  )

  insert into #assetsMovementTypes
  select item 
    from [dbo].[fnSplit] (@assetMovementTypeIds, @sDelimiter)


  -- Calcula las ubicaciones hijas de las ubicaci贸n en el origen.
  if object_id('tempdb..#sourceLocations') is not null
    drop table #sourceLocations

  create table #sourceLocations
  (
    locationId int
  )

  insert into #sourceLocations
  select item 
    from [dbo].[fnSplit] (@sourceLocationIds, @sDelimiter)

  insert into #sourceLocations
  select l.id
    from [dbo].[Location] l
    inner join #sourceLocations sl on l.parentId = sl.locationId
    left join #sourceLocations sl2 on l.id = sl2.locationId
  where sl2.locationId is null

  -- Calcula las ubicaciones hijas de las ubicaci贸n en el destino.
  if object_id('tempdb..#destinationLocations') is not null
    drop table #destinationLocations

  create table #destinationLocations
  (
    locationId int
  )

  insert into #destinationLocations
  select item 
    from [dbo].[fnSplit] (@destinationLocationIds, @sDelimiter)

  insert into #destinationLocations
  select l.id
    from [dbo].[Location] l
    inner join #destinationLocations dl on l.parentId = dl.locationId
    left join #destinationLocations dl2 on l.id = dl2.locationId
  where dl2.locationId is null

  -- 0. Filtra los movimientos
  if object_id('tempdb..#amhsr') is not null
    drop table #amhsr

  create table #amhsr
  (
      assetsMovementsHeaderId int not null 
    , creationDate datetime not null
    , sourceLocation nvarchar(255) not null
    , targetLocation nvarchar(255) not null
    , permissionRequired bit not null
    , assetsMovementsType nvarchar(255) not null
    , shippingGuideId int null
    , receptionGuideId int null
    , primary key(assetsMovementsHeaderId)
  )

  insert into #amhsr
  select  amh.id assetsMovementsHeaderId
        , amh.creationDate
        , sl.Name sourceLocation
        , dl.Name targetLocation
        , amh.permissionRequired
        , amt.description [assetsMovementsType]
        , sg.id shippingGuideId
        , rg.id receptionGuideId
    from [AssetsMovementsHeader] amh
    inner join [AssetsMovementsType] amt on amh.AssetMovementTypeId = amt.id
    inner join [Location] sl on amh.SourceLocationId = sl.id
    inner join [Location] dl on amh.DestinationLocationId = dl.id
    left join [ShippingGuide] sg on amh.ShippingGuideId = sg.id
    left join [ReceptionGuide] rg on amh.ReceptionGuideId = rg.id
  where 
    sl.id in 
    (
      select locationId
        from #sourceLocations
    ) -- se debe indicar al menos una ubicaci贸n origen.
    and (
          @destinationLocationIds is null 
          or 
          dl.id in 
          (
            select locationId
              from #destinationLocations
          )
        )
    and (
          @assetMovementTypeIds is null 
          or 
          amt.id in 
          (
            select assetMovementTypeId
              from #assetsMovementTypes
          )
        )
    and (@shippingNumber is null or (sg.ShippingNumber is not null and sg.ShippingNumber = @shippingNumber))
    and (@receptionNumber is null or (rg.ReceptionNumber is not null and rg.ReceptionNumber = @receptionNumber))
    and amh.CreationDate between  @fromDate and @toDate

  --  1. Cacula los remitos de las Gu铆as de Traspaso
  -- (Puede haber mas de una gu铆a de traspaso para una gu铆a de recepci贸n)
  if object_id('tempdb..#srn') is not null
    drop table #srn

  create table #srn
  (
      receptionGuideId int
    , shippingNumber nvarchar(255)
  )

  create index srnIX1 on #srn (receptionGuideId)

  insert into #srn
  select  rg.id [receptionGuideId]
        , isnull(sg.ShippingNumber, sg2.ShippingNumber) [shippingNumber]
    from #amhsr amh
    left join [ShippingGuide] sg on amh.ShippingGuideId = sg.id
    left join [ReceptionGuide] rg on amh.ReceptionGuideId = rg.id
    left join [ShippingAndReception] sar on rg.id = sar.ReceptionGuideId
    left join [ShippingGuide] sg2 on sar.ShippingGuideId = sg2.id

  if object_id('tempdb..#shippingReceptionNumbers') is not null
    drop table #shippingReceptionNumbers

  create table #shippingReceptionNumbers
  (
      receptionGuideId int
    , shippingNumber nvarchar(255)
  )

  create index shippingReceptionNumbersIX1 on #shippingReceptionNumbers (receptionGuideId)

  insert into #shippingReceptionNumbers
  select  p1.receptionGuideId
        , ( 
            select shippingNumber + ' - ' 
              from #srn p2
            where p2.receptionGuideId = p1.receptionGuideId
            order by shippingNumber
            for xml path('')
          ) as shippingNumbers
    from #srn p1
  group by receptionGuideId

  --  2. Calcula la descripci贸n del Articulo
  if object_id('tempdb..#amhArtCompleteDescription') is not null
    drop table #amhArtCompleteDescription

  create table #amhArtCompleteDescription
  (
      model nvarchar(255) not null
    , articleId int not null
    , articleCompleteDescription nvarchar(255) not null
  )

  create index amhArtCompleteDescriptionIX1 on #amhArtCompleteDescription (articleId)

  -- Solo de movimientos no manuales.
  insert into #amhArtCompleteDescription
  select  distinct
          m.description model
        , a.id articleId
        , a.codArt + ' - ' + m.description + ' - ' + b.code +
          case 
            when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
            when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
            when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
            when (ca.Generic = 1 and s.Generic = 1) then ''
          end [articleCompleteDescription]
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    inner join [AssetsMovementsItemsDetail] amid on ami.id = amid.AssetsMovementsItemId
    inner join [Article] a on amid.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
    inner join [Brand] b on a.brandId = b.id
    inner join [ColorArt] ca on a.ColorArtId = ca.id
    inner join [Size] s on a.SizeId = s.id
  where amh.[assetsMovementsType] not like '%Manual%'

  --  Solo de movimientos manuales.
  insert into #amhArtCompleteDescription
  select  distinct
          m.description model
        , a.id articleId
        , a.codArt + ' - ' + m.description + ' - ' + b.code +
          case 
            when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
            when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
            when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
            when (ca.Generic = 1 and s.Generic = 1) then ''
          end [articleCompleteDescription]
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    inner join [Article] a on ami.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
    inner join [Brand] b on a.brandId = b.id
    inner join [ColorArt] ca on a.ColorArtId = ca.id
    inner join [Size] s on a.SizeId = s.id
    left join #amhArtCompleteDescription amhacd on a.id = amhacd.articleId
  where amh.[assetsMovementsType] like '%Manual%'
    and amhacd.articleId is null

  --  3. Calcula las cantidades
  if object_id('tempdb..#amhQty') is not null
    drop table #amhQty

  create table #amhQty
  (
      assetsMovementHeaderId int not null
    , articleId int not null
    , packageQuantity int
    , articleQuantity int
  )

  create index amhQtyIX1 on #amhQty (assetsMovementHeaderId)

  -- Solo de movimientos no manuales.
  insert into #amhQty
  select  ami.assetsMovementHeaderId
        , amid.articleId
        , isnull(ami.packageQuantity, '') packageQuantity
        , count(amid.id) articleQuantity
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
    inner join [AssetsMovementsItemsDetail] amid on ami.id = amid.AssetsMovementsItemId
  where amh.[assetsMovementsType] not like '%Manual%'
  group by  ami.AssetsMovementHeaderId
          , amid.articleId
          , ami.packageQuantity

  -- Solo de movimientos manuales.
  insert into #amhQty
  select  ami.assetsMovementHeaderId
        , ami.articleId
        , isnull(ami.packageQuantity, '') packageQuantity
        , sum(ami.Quantity) articleQuantity
    from #amhsr amh
    inner join [AssetsMovementsItems] ami on amh.assetsMovementsHeaderId = ami.AssetsMovementHeaderId
  where amh.[assetsMovementsType] like '%Manual%'
  group by  ami.AssetsMovementHeaderId
          , ami.articleId
          , ami.packageQuantity

  -- 4. Consolida toda la informaci贸n.
  if object_id('tempdb..#amhReport') is not null
    drop table #amhReport

  create table #amhReport
  (
      [rowNumber] int not null
    , [Date] varchar(20) not null
    , [LocationOrigin] nvarchar(255)
    , [LocationDestination] nvarchar(255)
    , [Authorize] nvarchar(255)
    , [ShippingGuide] nvarchar(255)
    , [ReceptionGuide] nvarchar(255)
    , [ModelType] nvarchar(255)
    , [ArticleName] nvarchar(255)
    , [QuantityArticle] int
    , [PackageQuantity] int
    , [MovementType] nvarchar(255)
  )

  create index amhReportIX1 on #amhReport ([rowNumber])

  insert into #amhReport
  select  ROW_NUMBER() over (order by amh.creationDate asc) [RowNumber]
        , convert(varchar, amh.creationDate, 103) + ' ' + convert(varchar, amh.creationDate, 108) [Date]
        , amh.sourceLocation [LocationOrigin]
        , amh.targetLocation [LocationDestination]
        , case amh.PermissionRequired when 0 then 'No ' else '' end + 'Requirio Autorizaci贸n' [Authorize]
        , isnull(sg.ShippingNumber, srn.ShippingNumber) [ShippingGuide]
        , isnull(rg.ReceptionNumber, '') [ReceptionGuide]
        , amhacd.model [ModelType]
        , amhacd.articleCompleteDescription [ArticleName]
        , amhQty.articleQuantity [QuantityArticle]
        , amhQty.packageQuantity [PackageQuantity]
        , amh.assetsMovementsType [MovementType]
    from #amhsr amh
    left join [ShippingGuide] sg on amh.ShippingGuideId = sg.id
    left join [ReceptionGuide] rg on amh.ReceptionGuideId = rg.id
    left join #shippingReceptionNumbers srn on rg.id = srn.receptionGuideId
    inner join #amhQty amhQty on amh.assetsMovementsHeaderId = amhQty.AssetsMovementHeaderId
    inner join #amhArtCompleteDescription amhacd on amhQty.articleId = amhacd.articleId

  select @totalRowCount = @@ROWCOUNT

  -- Aplica paginaci贸n sobre el resultado obtenido.
  select  p.[RowNumber]
        , p.[Date]
        , p.[LocationOrigin]
        , p.[LocationDestination]
        , p.[Authorize]
        , p.[ShippingGuide]
        , p.[ReceptionGuide]
        , p.[ModelType]
        , p.[ArticleName]
        , p.[QuantityArticle]
        , p.[PackageQuantity]
        , p.[MovementType]
    from #amhReport p
  where p.[rowNumber] BETWEEN ((@pageNumber - 1) * @pageSize + 1) AND (@pageNumber * @pageSize)

  set @rc = @@error

  set nocount off;

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_clearAll]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[audit_clearAll]
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.
  declare @rc int

  set nocount on;
  -- Deshabilita todas las restricciones.
  exec sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

  -- Elimina los datos de todas las tablas.
  exec sp_MSForEachTable "SET QUOTED_IDENTIFIER ON; DELETE FROM ?"

  -- Habilita todas las restricciones.
  exec sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

  set @rc = @@error

  set nocount off;

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadArticle]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadArticle]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Article]'
  set @columnsName = '[Id], [CodArt], [ModelId], [ColorArtId], [SizeId], [BrandId], [ExternalCode], [Deleted], [Excluded]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadAssetsMovementsType]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadAssetsMovementsType]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[AssetsMovementsType]'
  set @columnsName = '[Id], [Description], [Deleted]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadAuditGuideTypeError]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadAuditGuideTypeError]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[AuditGuideTypeError]'
  set @columnsName = '[Id], [Description]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadBrand]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadBrand]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Brand]'
  set @columnsName = '[Id], [Code], [Description], [ExternalCode], [Deleted], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadCategory]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[audit_downloadCategory]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Category]'
  set @columnsName = '[Id], [Code], [Description], [ExternalCode], [Remarks], [ParentId], [Deleted], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate], [IsComposition]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadCheckPoint]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[audit_downloadCheckPoint]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[CheckPoint]'
  set @columnsName = '[Id], [Code], [Name], [IpService], [IpClient], [Deleted], [CheckpointTypeId]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadColorArt]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadColorArt]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[ColorArt]'
  set @columnsName = '[Id], [Description], [Generic]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadCostCenter]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadCostCenter]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[CostCenter]'
  set @columnsName = '[Id], [ExternalCode], [Name], [Remarks], [Deleted], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadEntity]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadEntity]
(
    @tableName nvarchar(64)
  , @columnsName nvarchar(max)
  , @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
  , @whereCondition nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int

  declare @statement nvarchar(max)
  declare @targetStatment nvarchar(128)
  declare @sourceStatment nvarchar(128)
  declare @setIdentityInsertStament nvarchar(512)

  set @targetStatment = + @targetDbName + '.[dbo].' + @tableName
  set @sourceStatment = + @sourceDbName + '.[dbo].' + @tableName

  -- WARNING: SGA 24/04/2017. la sentencia SET IDENTITY_INSERT solo funciona si se ejecuta del lado del servidor
  -- en donde se encuentra la tabla f韘icamente.
  set @statement = 'SET IDENTITY_INSERT ' + @targetStatment + ' ON;'
  set @statement = @statement + 'insert into ' + @targetStatment + ' (' + @columnsName + ') '
  set @statement = @statement + 'select s.* from [MasterLinkedServer].'+ @sourceStatment + ' s '
  set @statement = @statement + 'left join '+ @targetStatment + ' t on s.id = t.id '

  if (@whereCondition is null)
  begin
    set @whereCondition = 'where t.id is null'
  end
  else
  begin
    set @whereCondition = @whereCondition + ' and t.id is null'
  end --if

  set @statement = @statement + @whereCondition + ';'

  set @statement = @statement + 'SET IDENTITY_INSERT ' + @targetStatment + ' OFF;'

  exec sp_executesql @statement

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadItem]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[audit_downloadItem]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)
 
  set @tableName = '[Item]'
  set @columnsName = '[Id], [Epc], [LastDateMove], [ExternalCode], [Remarks], [LocationId], [StateTagsId], [SupplierId], [ArticleId], [Excluded], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate], [DeletedDate], [TotalWashCount], [CurrentWashCount], [LastWashDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadLocation]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[audit_downloadLocation]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Location]'
  set @columnsName = '[Id], [NameShort], [Name], [Cuit], [Phone], [Address], [Town], [ZipCode], [ParentId], [Remarks], [RecepcionRfid], [RecepcionManual], [LocationInterna], [ExternalCode], [GeoreferenceLoc], [ProvinceId], [CostCenterId], [Deleted], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate], [Laundry], [SinRecepcion], [Restriction], [LocationExterna], [AutoStartDelivery], [DaysForDeliveryGuide]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadMasters]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadMasters]
(
  @clearAll bit
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.
  declare @rc int
  declare @sourceDbName nvarchar(64)
  declare @targetDbName nvarchar(64)

  -- FIXME: SGA 10/05/2017. Analizar con FL si tiene sentido parametrizar los nombres de BD origen/destino.
  set @sourceDbName = '[LaundryRFID]'
  set @targetDbName = '[LaundryRFID_Audit]'

  -- Borra todos los datos previos.
  if (@clearAll = 1)
  begin
    exec @rc = [dbo].[audit_clearAll]
  end

  -- Deshabilita todas las restricciones.
  exec @rc = sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL"

  -- Descarga los maestros de seguridad y parametros del sistema.
  exec @rc = [dbo].[audit_downloadUserAccount] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadRole] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadSysFunction] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadSysParam] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadUserAccountRole] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadPermission] @sourceDbName, @targetDbName

  -- Descarga los maestros de ubicaciones.
  exec @rc = [dbo].[audit_downloadCostCenter] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadLocation] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadProvince] @sourceDbName, @targetDbName

  -- Descarga los maestros de articulos.
  exec @rc = [dbo].[audit_downloadArticle] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadBrand] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadCategory] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadColorArt] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadModel] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadSize] @sourceDbName, @targetDbName

  -- Descarga los maestros de 铆tems.
  exec @rc = [dbo].[audit_downloadAuditGuideTypeError] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadAssetsMovementsType] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadCheckPoint] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadStateTags] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadSupplier] @sourceDbName, @targetDbName
  exec @rc = [dbo].[audit_downloadItem] @sourceDbName, @targetDbName

  -- Restablece todas las restricciones.
  exec @rc = sp_msforeachtable "ALTER TABLE ? CHECK CONSTRAINT ALL"

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadModel]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[audit_downloadModel]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Model]'
  set @columnsName = '[Id], [Code], [Description], [ItemsPerPackage], [PriceUnit], [ExternalCode], [WetWeight], [DryWeight], [PrintingType], [CategoryId], [Excluded], [Deleted], [TagsAsig], [UsesSize], [UsesColor], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate], [IsPrimary], [IsSecondary], [WashCountLimit], [WashCountAlert]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadPermission]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadPermission]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Permission]'
  set @columnsName = '[Id], [RoleId], [SysFunctionId], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadProvince]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadProvince]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Province]'
  set @columnsName = '[Id], [Name]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadRole]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadRole]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Role]'
  set @columnsName = '[Id], [Name], [Description], [Deleted], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadSize]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadSize]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Size]'
  set @columnsName = '[Id], [Description], [Generic]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadStateTags]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadStateTags]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[StateTags]'
  set @columnsName = '[Id], [Name]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadSupplier]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadSupplier]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[Supplier]'
  set @columnsName = '[Id], [Name], [ContactName], [Address], [ZipCode], [Phone], [Email], [Cuit], [Remarks], [ExternalCode], [Deleted], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadSysFunction]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadSysFunction]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[SysFunction]'
  set @columnsName = '[Id], [Code], [Name], [Description]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadSysParam]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadSysParam]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[SysParam]'
  set @columnsName = '[Id], [Name], [Value], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadUserAccount]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadUserAccount]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[UserAccount]'
  set @columnsName = '[Id], [Epc], [Lang], [FileNumber], [FirstName], [LastName], [UserName], [Password], '
  set @columnsName = @columnsName + '[MustChangePassword], [LastLogonDate], [LocationId], [Deleted], [Version], [CreationUserAccountId], '
  set @columnsName = @columnsName + '[CreationDate], [ModifiedUserAccountId], [ModifiedDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_downloadUserAccountRole]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[audit_downloadUserAccountRole]
(
    @sourceDbName nvarchar(64)
  , @targetDbName nvarchar(64)
)
with recompile
as
begin
  -- "MasterLinkedServer": Servidor enlazado a la BD principal LaundryRFID.

  declare @rc int
  declare @tableName nvarchar(64)
  declare @columnsName nvarchar(max)
  declare @whereCondition nvarchar(64)

  set @tableName = '[UserAccountRole]'
  set @columnsName = '[Id], [RoleId], [UserAccountId], [Version], [CreationUserAccountId], [CreationDate], [ModifiedUserAccountId], [ModifiedDate]'

  exec @rc = [dbo].[audit_downloadEntity] @tableName, @columnsName, @sourceDbName, @targetDbName, @whereCondition

  set @rc = @@error

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_export]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[audit_export]
(
    @locationId int
  , @dateFrom datetime
  , @dateTo datetime
)
with recompile
as
begin
  declare @rc int

  set nocount on;

  -- WARNING: SGA 03/07/2017.
  -- Establece la fecha m醲ima que permite el motor de BD.
  declare @maxDatetime datetime
  -- WARNING: SGA 03/07/2017. Establece el estilo ODBC canonical yyyy-mm-dd hh:mi:ss(24h) 
  -- Para evitar el error:
  -- Msg 242, Level 16, State 3, Line 8
  -- La conversi髇 del tipo de datos char a datetime produjo un valor datetime fuera de intervalo.
  set @maxDatetime = convert(datetime, '9999-12-31 23:59:59', 20)

  set @dateTo = isnull(@dateTo, dateadd(dd, -1, @maxDatetime))
  set @dateTo = dateadd(dd, 1, dateadd(ss, -1, @dateTo))

  -- 0. Filtra la auditoria
  if object_id('tempdb..#agsr') is not null
    drop table #agsr

  create table #agsr
  (
      AuditGuideId int not null
    , Number nvarchar(40) not null 
    , GenerateDate datetime not null
    , LocationId int not null
    , ArticleId int not null
    , ItemId int not null
    , AuditGuideTypeErrorId int null
    , primary key(AuditGuideId, LocationId, ItemId)
  )

  insert into #agsr
  select  ag.[Id] [AuditGuideId]
        , ag.[Number]
        , ag.[GenerateDate]
        , ag.[LocationId]
        , agd.[ArticleId]
        , agd.[ItemId]
        , aged.[AuditGuideTypeErrorId]
    from [AuditGuide] ag
      inner join [Location] l on ag.LocationId = l.Id
      inner join [AuditGuideDetail] agd on ag.Id = agd.AuditGuideId
      inner join [Item] i on agd.ItemId = i.Id
      inner join [AuditGuideError] age on ag.Id = age.AuditGuideId
      left join [AuditGuideErrorDetail] aged on age.Id = aged.AuditGuideErrorId
                                            and agd.ItemId = aged.ItemId
  where (l.id = @locationId or l.ParentId = @locationId) -- Incluye la roperia m醩 las ubicaciones internas
    and ag.[GenerateDate] between @dateFrom and @dateTo


  --  1. Calcula la descripci髇 del Articulo
  if object_id('tempdb..#agArtCompleteDescription') is not null
    drop table #agArtCompleteDescription

  create table #agArtCompleteDescription
  (
      model nvarchar(255) not null
    , articleId int not null
    , articleCompleteDescription nvarchar(255) not null
  )

  create index agArtCompleteDescriptionIX1 on #agArtCompleteDescription (articleId)

  insert into #agArtCompleteDescription
  select  distinct
          m.description Model
        , a.id ArticleId
        , a.codArt + ' - ' + m.description + ' - ' + b.code +
          case 
            when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
            when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
            when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
            when (ca.Generic = 1 and s.Generic = 1) then ''
          end [ArticleCompleteDescription]
    from #agsr ag
      inner join [Article] a on ag.ArticleId = a.Id
      inner join [Model] m on a.modelId = m.Id
      inner join [Brand] b on a.brandId = b.Id
      inner join [ColorArt] ca on a.ColorArtId = ca.Id
      inner join [Size] s on a.SizeId = s.Id


  -- 2. Consolida toda la informaci?n.
  if object_id('tempdb..#agExport') is not null
    drop table #agExport

  create table #agExport
  (
      [rowNumber] int not null
    , [Number] varchar(40) not null
    , [GenerateDate] varchar(20) not null
    , [LocationShortName] nvarchar(255)
    , [Model] nvarchar(255)
    , [ArticleCompleteDescription] nvarchar(255)
    , [Epc] nvarchar(255)
    , [AuditGuideTypeError] nvarchar(255)
  )

  create index agExportIX1 on #agExport ([rowNumber])

  insert into #agExport
  select  ROW_NUMBER() over (order by ag.Number asc) [RowNumber]
        , ag.Number
        , convert(varchar, ag.GenerateDate, 103) + ' ' + convert(varchar, ag.GenerateDate, 108) [GenerateDate]
        , l.NameShort LocationShortName
        , agacd.Model
        , agacd.ArticleCompleteDescription
        , i.Epc
        , isnull(agte.Description, '') AuditGuideTypeError
    from #agsr ag
      inner join [Location] l on ag.LocationId = l.Id
      inner join [Item] i on ag.ItemId = i.Id
      inner join #agArtCompleteDescription agacd on ag.ArticleId = agacd.articleId
      left join [AuditGuideTypeError] agte on ag.AuditGuideTypeErrorId = agte.Id

  select  p.[RowNumber]
        , p.[Number]
        , p.[GenerateDate]
        , p.[LocationShortName]
        , p.[Model]
        , p.[ArticleCompleteDescription]
        , p.[Epc]
        , p.[AuditGuideTypeError]
    from #agExport p

  set @rc = @@error

  set nocount off;

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_export_withPack]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[audit_export_withPack]
    @locationId int
  , @dateFrom datetime
  , @dateTo datetime
AS

begin
  declare @rc int

  set nocount on;

  -- WARNING: SGA 03/07/2017.
  -- Establece la fecha m醲ima que permite el motor de BD.
  declare @maxDatetime datetime
  -- WARNING: SGA 03/07/2017. Establece el estilo ODBC canonical yyyy-mm-dd hh:mi:ss(24h) 
  -- Para evitar el error:
  -- Msg 242, Level 16, State 3, Line 8
  -- La conversi髇 del tipo de datos char a datetime produjo un valor datetime fuera de intervalo.
  set @maxDatetime = convert(datetime, '9999-12-31 23:59:59', 20)

  set @dateTo = isnull(@dateTo, dateadd(dd, -1, @maxDatetime))
  set @dateTo = dateadd(dd, 1, dateadd(ss, -1, @dateTo))

  -- 0. Filtra la auditoria
  if object_id('tempdb..#agsr') is not null
    drop table #agsr

  create table #agsr
  (
      AuditGuideId int not null
    , Number nvarchar(40) not null 
    , GenerateDate datetime not null
    , LocationId int not null
    , ArticleId int not null
    , ItemId int not null
    , AuditGuideTypeErrorId int null
    , primary key(AuditGuideId, LocationId, ItemId)
	, packId int null
  )

  insert into #agsr
  select  ag.[Id] [AuditGuideId]
        , ag.[Number]
        , ag.[GenerateDate]
        , ag.[LocationId]
        , agd.[ArticleId]
        , agd.[ItemId]
        , aged.[AuditGuideTypeErrorId]
		, agd.[PackId]
    from [AuditGuide] ag
      inner join [Location] l on ag.LocationId = l.Id
      inner join [AuditGuideDetail] agd on ag.Id = agd.AuditGuideId
      inner join [Item] i on agd.ItemId = i.Id
      inner join [AuditGuideError] age on ag.Id = age.AuditGuideId
      left join [AuditGuideErrorDetail] aged on age.Id = aged.AuditGuideErrorId
                                            and agd.ItemId = aged.ItemId
  where (l.id = @locationId or l.ParentId = @locationId) -- Incluye la roperia m醩 las ubicaciones internas
    and ag.[GenerateDate] between @dateFrom and @dateTo


  --  1. Calcula la descripci髇 del Articulo
  if object_id('tempdb..#agArtCompleteDescription') is not null
    drop table #agArtCompleteDescription

  create table #agArtCompleteDescription
  (
      model nvarchar(255) not null
    , articleId int not null
    , articleCompleteDescription nvarchar(255) not null
  )

  create index agArtCompleteDescriptionIX1 on #agArtCompleteDescription (articleId)

  insert into #agArtCompleteDescription
  select  distinct
          m.description Model
        , a.id ArticleId
        , a.codArt + ' - ' + m.description + ' - ' + b.code +
          case 
            when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
            when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
            when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
            when (ca.Generic = 1 and s.Generic = 1) then ''
          end [ArticleCompleteDescription]

    from #agsr ag
      inner join [Article] a on ag.ArticleId = a.Id
      inner join [Model] m on a.modelId = m.Id
      inner join [Brand] b on a.brandId = b.Id
      inner join [ColorArt] ca on a.ColorArtId = ca.Id
      inner join [Size] s on a.SizeId = s.Id


  -- 2. Consolida toda la informaci?n.
  if object_id('tempdb..#agExport') is not null
    drop table #agExport

  create table #agExport
  (
      [rowNumber] int not null
    , [Number] varchar(40) not null
    , [GenerateDate] varchar(20) not null
    , [LocationShortName] nvarchar(255)
    , [Model] nvarchar(255)
    , [ArticleCompleteDescription] nvarchar(255)
    , [Epc] nvarchar(255)
    , [AuditGuideTypeError] nvarchar(255)
	, [PackId] int null
	, [Batch] nvarchar(50) null
	, [Package] nvarchar(max) null
  )

  create index agExportIX1 on #agExport ([rowNumber])

  insert into #agExport
  select  ROW_NUMBER() over (order by ag.Number asc) [RowNumber]
        , ag.Number
        , convert(varchar, ag.GenerateDate, 103) + ' ' + convert(varchar, ag.GenerateDate, 108) [GenerateDate]
        , l.NameShort LocationShortName
        , agacd.Model
        , agacd.ArticleCompleteDescription
        , i.Epc
        , isnull(agte.Description, '') AuditGuideTypeError
		,ag.packId
		,p.Batch
		,pkg.Description
    from #agsr ag
      inner join [Location] l on ag.LocationId = l.Id
      inner join [Item] i on ag.ItemId = i.Id
      inner join #agArtCompleteDescription agacd on ag.ArticleId = agacd.articleId
      left join [AuditGuideTypeError] agte on ag.AuditGuideTypeErrorId = agte.Id
	  Left join [Pack] p on ag.PackId = p.Id
	  Left join [Package] pkg on p.PackageId = pkg.Id

  select  p.[RowNumber]
        , p.[Number]
        , p.[GenerateDate]
        , p.[LocationShortName]
        , p.[Model]
        , p.[ArticleCompleteDescription]
        , p.[Epc]
        , p.[AuditGuideTypeError]
		, p.[PackId]
		, p.[Batch]
		, p.[Package]
    from #agExport p

  set @rc = @@error

  set nocount off;

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[audit_import]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[audit_import]
(
  @filename varchar(255)
)
with recompile
as
begin
  -- Cuando activa XACT_ABORT, casi todos los errores tienen el mismo efecto: 
  -- cualquier transacci髇 abierta se retrotrae y la ejecuci髇 se cancela.

  -- El efecto de NOCOUNT es que suprime mensajes como (1 fila (s) afectada (s)) 
  -- que puede ver en la pesta馻 Mensaje en SQL Server Management Studio. 
  -- Si bien estos recuentos de filas pueden ser 鷗iles cuando trabajas de forma
  -- interactiva en SSMS, pueden degradar el rendimiento de una aplicaci髇 
  -- debido al aumento del tr醘ico de la red. 
  set xact_abort, nocount on

  begin try

    begin transaction

      exec dbo.[auditGuideRow_insertUnassignedItems] @filename

      exec dbo.[auditGuideRow_insertAuditGuides] @filename

      exec dbo.[auditGuideRow_insertAuditGuideDetail] @filename

      exec dbo.[auditGuideRow_insertAuditGuideError] @filename

      exec dbo.[auditGuideRow_insertAuditGuideErrorDetail] @filename

      exec dbo.[auditGuideRow_insertAssetsMovementsHeader] @filename

      exec dbo.[auditGuideRow_insertAssetsMovementsItems] @filename

      exec dbo.[auditGuideRow_insertAssetsMovementsItemsDetail] @filename

      exec dbo.[auditGuideRow_updateItems] @filename

      exec dbo.[auditGuideRow_insertAssetsTraceability] @filename

	  exec dbo.[auditGuideRow_insertAssetsTraceabilityForRemoved] @filename

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_clear]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_clear]
(
  @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

    delete agr
      from [AuditGuideRow] agr
    where agr.[Filename] = @filename

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_clearDelivered]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[auditGuideRow_clearDelivered]
(
  @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

    delete agr
      from [AuditGuideRow] agr
	  inner join [Item] i on agr.[ItemId] = i.[Id]
    where agr.[Filename] = @filename and i.StateTagsId = 6 --Entregado

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAssetsMovementsHeader]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_insertAssetsMovementsHeader]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AssetsMovementsHeader]
      ( 
          [SourceLocationId]
        , [DestinationLocationId]
        , [PermissionRequired]
        , [AssetMovementTypeId]
        , [Version]
        , [CreationUserAccountId]
        , [CreationDate]
        , [AuditGuideId]
      )
      select  distinct
              agr.[LocationId]
            , agr.[LocationId]
            , 0 --No requiere permisos
            , 37 -- Movimiento de Auditoria
            , 1 -- Versi髇
            , 1 -- Admin
            , agr.[GenerateDate]
            , ag.[Id]
      from [AuditGuideRow] agr
        inner join [AuditGuide] ag on agr.[Number] = ag.[Number]
      where agr.[Filename] = @filename

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch
end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAssetsMovementsItems]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_insertAssetsMovementsItems]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AssetsMovementsItems]
      (
          [AssetsMovementHeaderId]
        , [Quantity]
        , [Version]
        , [CreationUserAccountId]
        , [CreationDate]
        , [ModelId]
        , [ArticleId]
      )
      select  amh.[Id]
            , sum(agd.[Quantity]) [Quantity] -- Cantidad
            , agd.[Version]
            , agd.[CreationUserAccountId]-- Admin
            , agd.[CreationDate]
            , agd.[ModelId]
            , agd.[ArticleId]
      from [AuditGuideRow] agr
        inner join [AuditGuide] ag on agr.[Number] = ag.[Number]
        inner join [AuditGuideDetail] agd on ag.[Id] = agd.[AuditGuideId]
                                  and agr.[ItemId] = agd.[ItemId]
        inner join [AssetsMovementsHeader] amh on ag.[Id] = amh.[AuditGuideId]
      where agr.[Filename] = @filename
      group by  amh.[Id]
              , agd.[Version]
              , agd.[CreationUserAccountId]-- Admin
			  , agd.[CreationDate]
              , agd.[ModelId]
              , agd.[ArticleId]

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAssetsMovementsItemsDetail]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_insertAssetsMovementsItemsDetail]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AssetsMovementsItemsDetail]
      (
          [AssetsMovementsItemId]
        , [ItemId]
        , [Version]
        , [CreationUserAccountId]
        , [CreationDate]
        , [ArticleId]
      )
      select  ami.[Id]
            , agd.[ItemId]
            , agd.[Version]
            , agd.[CreationUserAccountId]
            , agd.[CreationDate]
            , agd.[ArticleId]
      from [AuditGuideRow] agr
        inner join [AuditGuide] ag on agr.[Number] = ag.[Number]
        inner join [AuditGuideDetail] agd on ag.[Id] = agd.[AuditGuideId]
                                  and agr.[ItemId] = agd.[ItemId]
        inner join [AssetsMovementsHeader] amh on ag.[Id] = amh.[AuditGuideId]
        inner join [AssetsMovementsItems] ami on amh.[Id] = ami.[AssetsMovementHeaderId]
                                             and agd.ArticleId = ami.ArticleId
      where agr.[Filename] = @filename

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAssetsTraceability]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_insertAssetsTraceability]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AssetsTraceability]
      (
          [ItemId]
        , [StateTagId]
        , [LocationId]
        , [Version]
        , [CreationUserAccountId]
        , [CreationDate]
        , [AssetMovementTypeId]
		, [ArticleId]
      )
      select  agr.[ItemId]
            , 1 -- En Ubicaci?n
            , agr.[LocationId]
            , agd.[Version]
            , agd.[CreationUserAccountId]
            , agd.[CreationDate]
            , 37 -- Auditoria
			, i.[ArticleId]
      from [AuditGuideRow] agr
        inner join [AuditGuide] ag on agr.[Number] = ag.[Number]
        inner join [AuditGuideDetail] agd on ag.[Id] = agd.[AuditGuideId]
                                  and agr.[ItemId] = agd.[ItemId]
        inner join [Item] i on agr.[ItemId] = i.[Id]
		inner join [Article] a on i.[ArticleId] = a.[Id]
      where agr.[Filename] = @filename

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAssetsTraceabilityForRemoved]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[auditGuideRow_insertAssetsTraceabilityForRemoved]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AssetsTraceability]
      (
          [ItemId]
        , [StateTagId]
        , [LocationId]
        , [Version]
        , [CreationUserAccountId]
        , [CreationDate]
        , [AssetMovementTypeId]
		, [ArticleId]
      )
      select  agr.[ItemId]
            , 1 -- En Ubicaci?n
            , agr.[LocationId]
            , agd.[Version]
            , agd.[CreationUserAccountId]
            , agd.[CreationDate]
            , 63 -- Restauraci髇 por Baja en Inventario
			, i.[ArticleId]
      from [AuditGuideRow] agr
        inner join [AuditGuide] ag on agr.[Number] = ag.[Number]
        inner join [AuditGuideDetail] agd on ag.[Id] = agd.[AuditGuideId]
                                  and agr.[ItemId] = agd.[ItemId]
        inner join [Item] i on agr.[ItemId] = i.[Id]
		inner join [Article] a on i.[ArticleId] = a.[Id]
      where agr.AuditGuideTypeErrorId = 4 and agr.[Filename] = @filename

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAuditGuideDetail]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[auditGuideRow_insertAuditGuideDetail]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AuditGuideDetail]
      (
          [AuditGuideId]
        , [ItemId]
        , [ArticleId]
        , [ModelId]
        , [Quantity]
        , [Version]
        , [CreationUserAccountId]
        , [CreationDate]
		, [PackId]
      )
      select  ag.[Id]
            , i.[Id]
            , a.[Id]
            , m.[Id]
            , 1 -- Cantidad
            , 1 -- Versi髇
            , 1 -- Admin
            , agr.[GenerateDate]
			, max_p_i.[PackId]
      from [AuditGuideRow] agr
        inner join [AuditGuide] ag on agr.[Number] = ag.[Number]
        inner join [Item] i on agr.[ItemId] = i.[Id]
        inner join [Article] a on i.[ArticleId] = a.[Id]
        inner join [Model] m on a.[ModelId] = m.[Id]
		left join 
		(
			select MIN(p_i.[PackId]) as [PackId], p_i.[ItemId] 
			from [PackItem] p_i
			inner join [Pack] p on p_i.[PackId] = p.Id
			where p.[PackStatusId] != 4 and p.[PackStatusId] != 5 -- excluye Packs Finalizados o Cancelados
			group by p_i.[ItemId]
		) max_p_i on i.Id = max_p_i.ItemId
      where agr.[Filename] = @filename
	  and not exists (select 1 from [AuditGuideDetail] where [AuditGuideId] = ag.[Id] and [ItemId] = i.[Id])

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAuditGuideError]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_insertAuditGuideError]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AuditGuideError]
      (
          [AuditGuideId]
        , [IncorrectLocation]
        , [Lost]
        , [InTransit]
        , [Eliminated]
        , [PendingSend]
        , [PendingRead]
        , [Unassigned]
      )
      select  ag.[Id]
            , sum (
                    case [AuditGuideTypeErrorId] 
                      when 1 
                      then 1 
                      else 0 
                    end
                  )
            , sum (
                    case [AuditGuideTypeErrorId] 
                      when 2 
                      then 1 
                      else 0 
                    end
                  )
            , sum (
                    case [AuditGuideTypeErrorId] 
                      when 3 
                      then 1 
                      else 0 
                      end
                  )
            , sum (
                    case [AuditGuideTypeErrorId] 
                      when 4 
                      then 1 
                      else 0 
                      end
                  )
            , sum (
                    case [AuditGuideTypeErrorId] 
                      when 5 
                      then 1 
                      else 0 
                      end
                  )
            , sum (
                    case [AuditGuideTypeErrorId] 
                      when 6 
                      then 1 
                      else 0 
                    end
                  )
            , sum (
                    case [AuditGuideTypeErrorId] 
                      when 7 
                      then 1 
                      else 0 
                    end
                  )
      from [AuditGuideRow] agr
        inner join [AuditGuide] ag on agr.[Number] = ag.[Number]
      where agr.[Filename] = @filename
      group by ag.[Id]

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAuditGuideErrorDetail]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_insertAuditGuideErrorDetail]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AuditGuideErrorDetail]
      (
          [ItemId]
        , [AuditGuideTypeErrorId]
        , [AuditGuideErrorId]
      )
      select  agr.[ItemId]
            , agr.[AuditGuideTypeErrorId]
            , age.[Id]
      from [AuditGuideRow] agr
        inner join [AuditGuide] ag on agr.[Number] = ag.[Number]
        inner join [AuditGuideError] age on ag.[Id] = age.[AuditGuideId]
      where agr.[Filename] = @filename
        and agr.[AuditGuideTypeErrorId] is not null

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertAuditGuides]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_insertAuditGuides]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[AuditGuide]
      (
          [GenerateDate]
        , [LocationId]
        , [Number]
        , [Version]
        , [CreationUserAccountId]
        , [CreationDate]
      )
     	select distinct
              agr.[GenerateDate]
            , agr.[LocationId]
            , agr.[Number]
            , 1 -- Versi髇
            , 1 -- Admin
            , agr.[GenerateDate]
      from [AuditGuideRow] agr
      where agr.[Filename] = @filename

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_insertUnassignedItems]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_insertUnassignedItems]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      insert into [dbo].[Item]
      (
          [Epc]
        , [LastDateMove]
        , [LocationId]
        , [StateTagsId]
        , [ArticleId]
        , [Excluded]
        , [Version]
        , [CreationUserAccountId]
        , [CreationDate]
      )
      select  agr.[Epc]
            , agr.[GenerateDate]
            , agr.[LocationId]
            , 1 --En Ubicaci髇
            , a.[Id]
            , 0 -- No Excluido
            , 1 -- Versi髇
            , 1 -- Admin
            , agr.[GenerateDate]
      from [AuditGuideRow] agr
        cross join [Model] m
        inner join [Article] a on m.[Id] = a.[ModelId]
      where agr.[Filename] = @filename
        and agr.[ItemId] is null
        and agr.[AuditGuideTypeErrorId] = 7 -- Sin Asignar
        and m.[Id] = 52 --'TIPO INDEFINIDO'
        and a.[Id] = 582 --'TIPO INDEF'

      -- Actualiza las referencias.
      update agr
        set agr.[ItemId] = i.[Id]
      from [AuditGuideRow] agr
        inner join [Item] i on agr.[Epc] = i.[Epc]
      where agr.[Filename] = @filename
        and agr.[ItemId] is null

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch
end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_processFile]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_processFile]
(
    @filename varchar(255)
  , @incorrectLocation int output
  , @lost int output
  , @inTransit int output
  , @eliminated int output
  , @pendingSend int output
  , @pendingRead int output
  , @unassigned int output
  , @totalItems int out
  , @totalInvalidRows int out
)
with recompile
as
begin
  declare @rc int
  declare @processDate datetime

  set xact_abort, nocount on

  begin try

    set @processDate = getdate()

    begin transaction

      -- Completa y valida las claves foraneas.
      update agr
        set agr.[LocationId] = l.[Id]
          , agr.[ItemId] = i.[Id]
          , agr.[AuditGuideTypeErrorId] = agte.[Id]
          , agr.[AuditExists] = case 
                                  when ag.[Id] is null 
                                  then 0 
                                  else 1 
                                end
          , agr.[LocationExists] =  case 
                                      when l.[Id] is null 
                                      then 0 
                                      else 1 
                                    end
          , agr.[ItemExists] =  case 
                                  when i.[Id] is null 
                                  then 0 
                                  else 1 
                                end
          , agr.[AuditGuideTypeErrorExists] = case 
                                                when (agte.[Id] is null and agr.[AuditGuideTypeError] is not null) 
                                                then 0 
                                                else 1 
                                              end
          , agr.[ProcessDate] = @processDate
      from [AuditGuideRow] agr
        left join [Location] l on agr.LocationShortName = l.[NameShort]
        left join [Item] i on agr.[Epc] = i.[Epc]
        left join [AuditGuideTypeError] agte on agr.[AuditGuideTypeError] = agte.[Description]
        left join [AuditGuide] ag on agr.Number = ag.Number
      where agr.[Filename] = @filename
        and agr.[LocationId] is null
        and agr.[ItemId] is null
        and agr.[AuditGuideTypeErrorId] is null

      -- FIXME: SGA 30/06/2017. Contemplar caso que el item no exista pero el error es prenda no asignada.
      -- HACK: Conteo condicional. Enlace: https://stackoverflow.com/questions/3455201/count-based-on-condition-in-sql-server
      select  @totalItems = count(1)
            , @totalinvalidRows = sum(
                                      case 
                                        when  (
                                                    agr.[AuditExists] = 1 
                                                or agr.[LocationExists] = 0
                                                or agr.[AuditGuideTypeErrorExists] = 0
                                                or (agr.[ItemExists] = 0 and [AuditGuideTypeErrorId] <> 7)
                                              ) 
                                        then 1 
                                        else 0 
                                      end
                                    )
            , @incorrectLocation = sum(
                                        case [AuditGuideTypeErrorId] 
                                          when 1 
                                          then 1 
                                          else 0 
                                        end
                                      )
            , @lost = sum (
                            case [AuditGuideTypeErrorId] 
                              when 2 
                              then 1 
                              else 0 
                            end
                          )
            , @inTransit = sum(
                                case [AuditGuideTypeErrorId] 
                                  when 3 
                                  then 1 
                                  else 0 
                                  end
                              )
            , @eliminated = sum (
                                  case [AuditGuideTypeErrorId] 
                                    when 4 
                                    then 1 
                                    else 0 
                                    end
                                )
            , @pendingSend = sum(
                                  case [AuditGuideTypeErrorId] 
                                    when 5 
                                    then 1 
                                    else 0 
                                    end
                                )
            , @pendingRead = sum(
                                  case [AuditGuideTypeErrorId] 
                                    when 6 
                                    then 1 
                                    else 0 
                                  end
                                )
            , @unassigned = sum (
                                  case [AuditGuideTypeErrorId] 
                                    when 7 
                                    then 1 
                                    else 0 
                                  end
                                )
        from [AuditGuideRow] agr
      where agr.[Filename] = @filename

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_updateErrorTypeId]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[auditGuideRow_updateErrorTypeId]
(
  @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

    declare @processDate datetime
	select @processDate = GETDATE()

	if object_id('tempdb..#agr') is not null
			drop table #agr

	create table #agr
	(
		agrId int not null,
		itemId int not null,
		itemLocationId int not null,
		agrLocationId int not null,
		itemStateId int not null,
		creationDate datetime not null,
		errorTypeId int null
	)

	insert into #agr
	select agr.Id
		,  agr.ItemId
		,  i.LocationId
		,  agr.LocationId
		,  i.StateTagsId
		,  agr.creationDate
		,  null
	from AuditGuideRow agr
	inner join Item i on agr.ItemId = i.Id
	where agr.[Filename] = @filename


	update agr 
		set	itemStateId = at.StateTagId
		,	itemLocationId = at.LocationId
	from #agr agr
	inner join 
	(
		select MAX(tr.Id) as Id,
			tr.ItemId 
		from AssetsTraceability tr 
		inner join #agr agr on tr.ItemId = agr.itemId and tr.CreationDate < agr.creationDate
		group by tr.ItemId
	) t on agr.itemId = t.ItemId
	inner join AssetsTraceability at on t.Id = at.Id


	update agr
	set agr.errorTypeId = 
				case
					when agr.itemStateId in (2, 3, 4, 5) then agr.itemStateId
					when agr.itemStateId = 1 and agr.itemLocationId != agr.agrLocationId then 1
					when agr.itemStateId = 1 and a.ModelId = 52 then 7
				end
	from #agr agr
	inner join Item i on agr.itemId = i.Id
	inner join Article a on i.ArticleId = a.Id

	update agr
	set		agr.AuditGuideTypeErrorId = agrTemp.errorTypeId
		,	agr.AuditGuideTypeError = ate.Description
	from AuditGuideRow agr
	inner join #agr agrTemp on agrTemp.agrId = agr.Id
	inner join AuditGuideTypeError ate on ate.Id = agrTemp.errorTypeId

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[auditGuideRow_updateItems]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[auditGuideRow_updateItems]
(
    @filename varchar(255)
)
with recompile
as
begin
  set xact_abort, nocount on

  begin try

    begin transaction

      update i
        set i.[LocationId] = agr.LocationId
          , i.[StateTagsId] = 1 -- En Ubicaci髇.
          , i.[LastDateMove] = agr.[GenerateDate]
          , i.[Version] = i.[Version] + 1
          , i.[ModifiedDate] = agr.[GenerateDate]
          , i.[ModifiedUserAccountId] = 1 -- Admin
      from [AuditGuideRow] agr
        inner join [Item] i on agr.[ItemId] = i.[Id]
      where agr.[Filename] = @filename
        and i.[LastDateMove] < agr.[GenerateDate]

    commit transaction
  end try
  begin catch
    if @@trancount > 0
      rollback transaction

    exec exception_throw
    return 55555
  end catch

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[deliveryGuideDetail_getHistoricReport]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[deliveryGuideDetail_getHistoricReport]
(
    @fromDate datetime
  , @toDate datetime
  , @locationIds varchar(8000)
  , @employeeIds varchar(8000)
  , @pageNumber int
  , @pageSize int
  , @sortColumn varchar(32)
  , @sortOrder varchar(4)
  , @totalRowCount int output
)
with recompile
as
begin
    declare @rc int

    -- TODO: 21/03/2019 SG: Queda Pendiente modificar Alias en las diferentes tablas temporales 

    declare @sDelimiter varchar(1)
    set @sDelimiter = ','

    --  Calcula las ubicaciones
    if object_id('tempdb..#locationIds') is not null
        drop table #locationIds

    create table #locationIds
    (
        locationId int
    )

    insert into #locationIds
    select item 
        from [dbo].[fnSplit] (@locationIds, @sDelimiter)


    --  Calcula los empleados
    if object_id('tempdb..#employeeIds') is not null
        drop table #employeeIds

    create table #employeeIds
    (
        employeeId int
    )

    insert into #employeeIds
    select item 
        from [dbo].[fnSplit] (@employeeIds, @sDelimiter)


    -- Filtra los datos
    if object_id('tempdb..#deliveryGuideSR') is not null
        drop table #deliveryGuideSR

    create table #deliveryGuideSR
    (
            DeliveryGuideId int
        ,   DeliveryDate datetime not null
        ,   EmployeeDocumentNumber varchar(10) not null
        ,   EmployeeFirstName nvarchar(255) not null
        ,   EmployeeLastName nvarchar(255) not null
        ,   EmployeeCeco varchar(50) null
        ,   LocationOrigin nvarchar(255) not null
        ,   StateTag nvarchar(255) not null
        ,   Epc nvarchar(255) not null
        ,   ArticleId int null
        ,   StateTagId int null
        ,   ItemId int null
    )
    insert into #deliveryGuideSR
    select  dg.id
        ,   dg.DeliveryDate
        ,   e.DocumentNumber [EmployeeDocumentNumber]
        ,   e.FirstName [EmployeeFirstName]
        ,   e.LastName [EmployeeLastName]
        ,   e.Ceco [EmployeeCeco]
        ,   l.Name [LocationOrigin]
        ,   st.Name [StateTag]
        ,   i.Epc
        ,   a.id [ArticleId]
        ,   i.StateTagsId
        ,   i.Id [ItemId]
    from DeliveryGuideDetail dgd
    inner join DeliveryGuide dg ON dg.Id = dgd.DeliveryGuideId
    inner join Employee e ON e.Id = dg.EmployeeId
    inner join Location l ON l.Id = dg.LocationId
    inner join Article a ON a.Id = dgd.ArticleId
    inner join Item i ON i.Id = dgd.ItemId
    inner join StateTags st ON st.Id = i.StateTagsId
    where dg.DeliveryDate between @fromDate and @toDate
    and
    (
        @locationIds is null
        or 
        (
            dg.LocationId in
            (
            select locationId
                from #locationIds
            )
        )
    )
    and
    (
        @employeeIds is null 
        or 
        (
            dg.EmployeeId in
            (
            select employeeId
                from #employeeIds
            )
        )
    )

    select @totalRowCount = @@ROWCOUNT


    -- Calcula la descripci?n de los art?culos
    if object_id('tempdb..#itemArtCompleteDescription') is not null
        drop table #itemArtCompleteDescription

    create table #itemArtCompleteDescription
    (
            model nvarchar(255) not null
        ,   category nvarchar(255) not null
        ,   articleId int not null
        ,   articleCompleteDescription nvarchar(255) not null
    )

    create index itemArtCompleteDescriptionIX1 on #itemArtCompleteDescription (articleId)

    insert into #itemArtCompleteDescription
    select  distinct
            m.description model
        ,   isnull(c.description,'') category
        ,   a.id articleId
        ,   a.codArt + ' - ' + m.description + ' - ' + b.code +
            case 
                when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
                when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
                when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
                when (ca.Generic = 1 and s.Generic = 1) then ''
            end [articleCompleteDescription]
    from #deliveryGuideSR dgsr
    inner join [Article] a on dgsr.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
    left join [Category] c on m.categoryId = c.id
    inner join [Brand] b on a.brandId = b.id
    inner join [ColorArt] ca on a.ColorArtId = ca.id
    inner join [Size] s on a.SizeId = s.id


    -- Calcula la fecha de devoluci髇 a partir de la trazabilidad de cada prenda.
    if object_id('tempdb..#latestTraceabilityRecord') is not null
        drop table #latestTraceabilityRecord

    create table #latestTraceabilityRecord
    (
            DeliveryGuideId int not null
        ,   DeliveryDate datetime not null
        ,   itemId int not null
        ,   AssetsTraceabilityId int null
        ,   StateTagsId int null
        ,   ReturnDate datetime null
    )

    create index latestTraceabilityRecord_IX1 on #latestTraceabilityRecord ([itemId])

    insert into #latestTraceabilityRecord
    select  dgsr.DeliveryGuideId
          , dgsr.DeliveryDate
          , dgsr.ItemId [ItemId]
          , min(t.Id) [AssetsTraceabilityId]
          , null [StateTagsId]
          , null [ReturnDate]
    from #deliveryGuideSR dgsr
    left join AssetsTraceability t on dgsr.ItemId = t.ItemId and (DATEDIFF(SECOND, dgsr.DeliveryDate, t.CreationDate) > 2)
	where t.AssetMovementTypeId not in (21, 46) or (t.AssetMovementTypeId = 46 and t.StateTagId != 4)
    group by dgsr.DeliveryGuideId, dgsr.DeliveryDate, dgsr.ItemId

    update ltr
        set ltr.ReturnDate = t.CreationDate
        ,   ltr.StateTagsId = t.StateTagId
    from #latestTraceabilityRecord ltr
    inner join AssetsTraceability t on ltr.AssetsTraceabilityId = t.id


    -- Consolida toda la informaci髇.
    if object_id('tempdb..#resultReport') is not null
        drop table #resultReport

    create table #resultReport
    (
            DeliveryDate datetime not null
        ,   EmployeeDocumentNumber varchar(10) not null
        ,   EmployeeFirstName nvarchar(255) not null
        ,   EmployeeLastName nvarchar(255) not null
        ,   EmployeeCeco varchar(50) null
        ,   LocationOrigin nvarchar(255) not null
        ,   ArticleCompleteDescription nvarchar(100) not null
        ,   StateTag nvarchar(255) not null
        ,   ModelDescription nvarchar(255) not null
        ,   CategoryDescription nvarchar(255) not null
        ,   Epc nvarchar(255) not null
        ,   ReturnDate datetime null
    )

    create index resultReportIX1 on #resultReport ([DeliveryDate])

    insert into #resultReport
    select  dgsr.[DeliveryDate]
        ,   dgsr.[EmployeeDocumentNumber]
        ,   dgsr.[EmployeeFirstName]
        ,   dgsr.[EmployeeLastName]
        ,   dgsr.[EmployeeCeco]
        ,   dgsr.[LocationOrigin]
        ,   iacd.[ArticleCompleteDescription]
        ,   dgsr.[StateTag]
        ,   iacd.[model] [ModelDescription]
        ,   iacd.[category] [CategoryDescription]
        ,   dgsr.[Epc]
        ,   ltr.[ReturnDate]
    from #deliveryGuideSR dgsr
    inner join #itemArtCompleteDescription iacd on dgsr.articleId = iacd.articleId
    left join #latestTraceabilityRecord ltr on  dgsr.ItemId = ltr.ItemId 
                                            and dgsr.DeliveryGuideId = ltr.DeliveryGuideId


    select  rr.[DeliveryDate]
        ,   rr.[EmployeeDocumentNumber]
        ,   rr.[EmployeeFirstName]
        ,   rr.[EmployeeLastName]
        ,   rr.[EmployeeCeco]
        ,   rr.[LocationOrigin]
        ,   rr.[ArticleCompleteDescription]
        ,   rr.[StateTag]
        ,   rr.[ModelDescription]
        ,   rr.[CategoryDescription]
        ,   rr.[Epc]
        ,   rr.[ReturnDate]
    from #resultReport rr
    order by    case when @sortColumn = 'DeliveryDate' and @sortOrder = 'asc' then rr.[DeliveryDate] end asc,
                case when @sortColumn = 'DeliveryDate' and @sortOrder = 'desc' then rr.[DeliveryDate] end desc,
                case when @sortColumn = 'EmployeeDocumentNumber' and @sortOrder = 'asc' then rr.[EmployeeDocumentNumber] end asc,
                case when @sortColumn = 'EmployeeDocumentNumber' and @sortOrder = 'desc' then rr.[EmployeeDocumentNumber] end desc,
                case when @sortColumn = 'EmployeeFirstName' and @sortOrder = 'asc' then rr.[EmployeeFirstName] end asc,
                case when @sortColumn = 'EmployeeFirstName' and @sortOrder = 'desc' then rr.[EmployeeFirstName] end desc,
                case when @sortColumn = 'EmployeeLastName' and @sortOrder = 'asc' then rr.[EmployeeLastName] end asc,
                case when @sortColumn = 'EmployeeLastName' and @sortOrder = 'desc' then rr.[EmployeeLastName] end desc,
                case when @sortColumn = 'EmployeeCeco' and @sortOrder = 'asc' then rr.[EmployeeCeco] end asc,
                case when @sortColumn = 'EmployeeCeco' and @sortOrder = 'desc' then rr.[EmployeeCeco] end desc,
                case when @sortColumn = 'LocationOrigin' and @sortOrder = 'asc' then rr.[LocationOrigin] end asc,
                case when @sortColumn = 'LocationOrigin' and @sortOrder = 'desc' then rr.[LocationOrigin] end desc,
                case when @sortColumn = 'ReturnDate' and @sortOrder = 'asc' then rr.[ReturnDate] end asc,
                case when @sortColumn = 'ReturnDate' and @sortOrder = 'desc' then rr.[ReturnDate] end desc,
                case when @sortColumn = 'ArticleCompleteDescription' and @sortOrder = 'asc' then rr.[ArticleCompleteDescription] end asc,
                case when @sortColumn = 'ArticleCompleteDescription' and @sortOrder = 'desc' then rr.[ArticleCompleteDescription] end desc,
                case when @sortColumn = 'Epc' and @sortOrder = 'asc' then rr.[Epc] end asc,
                case when @sortColumn = 'Epc' and @sortOrder = 'desc' then rr.[Epc] end desc,
                case when @sortColumn = 'ModelDescription' and @sortOrder = 'asc' then rr.[ModelDescription] end asc,
                case when @sortColumn = 'ModelDescription' and @sortOrder = 'desc' then rr.[ModelDescription] end desc,
                case when @sortColumn = 'CategoryDescription' and @sortOrder = 'asc' then rr.[CategoryDescription] end asc,
                case when @sortColumn = 'CategoryDescription' and @sortOrder = 'desc' then rr.[CategoryDescription] end desc              
                
    offset (@pageNumber*@pageSize) rows
    fetch next @pageSize rows only;

  set @rc = @@error

  set nocount off;

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[deliveryGuideDetail_getItemsNotReturnedByEmployee]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[deliveryGuideDetail_getItemsNotReturnedByEmployee]
(
@employeeId int
, @pageNumber int
, @pageSize int
, @sortColumn varchar(32)
, @sortOrder varchar(4)
, @totalRowCount int output
)
with recompile
as
begin
declare @rc int

declare @filterDate datetime
set @filterDate = CONVERT(datetime, '2020-03-01 00:00:00.000', 121)

-- TODO: 21/03/2019 SG: Queda Pendiente modificar Alias en las diferentes tablas temporales 

-- Filtra los datos
if object_id('tempdb..#deliveryGuideSR') is not null
    drop table #deliveryGuideSR

create table #deliveryGuideSR
(
        DeliveryGuideId int
    ,   DeliveryDate datetime not null
    ,   EmployeeDocumentNumber varchar(10) not null
    ,   EmployeeFirstName nvarchar(255) not null
    ,   EmployeeLastName nvarchar(255) not null
    ,   Epc nvarchar(255) not null
    ,   ArticleId int null
    ,   StateTagId int null
    ,   ItemId int null
	,   Remarks varchar(max) null
)

create index deliveryGuideSRIX1 on #deliveryGuideSR (ArticleId)

insert into #deliveryGuideSR
select  dg.id
    ,   dg.DeliveryDate
    ,   e.DocumentNumber [EmployeeDocumentNumber]
    ,   e.FirstName [EmployeeFirstName]
    ,   e.LastName [EmployeeLastName]
    ,   i.Epc
    ,   a.id [ArticleId]
    ,   i.StateTagsId
    ,   i.Id [ItemId]
	,   dg.Remarks
from DeliveryGuideDetail dgd
inner join DeliveryGuide dg ON dg.Id = dgd.DeliveryGuideId
inner join Employee e ON e.Id = dg.EmployeeId
inner join Article a ON a.Id = dgd.ArticleId
inner join Item i ON i.Id = dgd.ItemId
inner join StateTags st ON st.Id = i.StateTagsId
where dg.EmployeeId = @employeeId and dg.DeliveryDate > @filterDate

select @totalRowCount = @@ROWCOUNT

-- Calcula la descripci贸n de los art铆culos
if object_id('tempdb..#itemArtCompleteDescription') is not null
    drop table #itemArtCompleteDescription

create table #itemArtCompleteDescription
(
        model nvarchar(255) not null
    ,   articleId int not null
    ,   articleCompleteDescription nvarchar(255) not null
)

create index itemArtCompleteDescriptionIX1 on #itemArtCompleteDescription (articleId)

insert into #itemArtCompleteDescription
select  distinct
        m.description model
    ,   a.id articleId
    ,   a.codArt + ' - ' + m.description + ' - ' + b.code +
        case 
            when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
            when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
            when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
            when (ca.Generic = 1 and s.Generic = 1) then ''
        end [articleCompleteDescription]
from #deliveryGuideSR dgsr
inner join [Article] a on dgsr.ArticleId = a.id
inner join [Model] m on a.modelId = m.id
inner join [Brand] b on a.brandId = b.id
inner join [ColorArt] ca on a.ColorArtId = ca.id
inner join [Size] s on a.SizeId = s.id


-- Calcula la fecha de devoluci贸n a partir de la trazabilidad de cada prenda.
if object_id('tempdb..#latestTraceabilityRecord') is not null
    drop table #latestTraceabilityRecord

create table #latestTraceabilityRecord
(
        DeliveryGuideId int not null
    ,   DeliveryDate datetime not null
    ,   itemId int not null
    ,   AssetsTraceabilityId int null
    ,   StateTagsId int null
    ,   ReturnDate datetime null
)

create index latestTraceabilityRecord_IX1 on #latestTraceabilityRecord ([itemId])

insert into #latestTraceabilityRecord
select  dgsr.DeliveryGuideId
      , dgsr.DeliveryDate
      , dgsr.ItemId [ItemId]
      , min(t.Id) [AssetsTraceabilityId]
      , null [StateTagsId]
      , null [ReturnDate]
from #deliveryGuideSR dgsr
left join AssetsTraceability t on dgsr.ItemId = t.ItemId and (DATEDIFF(SECOND, dgsr.DeliveryDate, t.CreationDate) > 2)
where t.AssetMovementTypeId not in (21, 46) or (t.AssetMovementTypeId = 46 and t.StateTagId != 4)
group by dgsr.DeliveryGuideId, dgsr.DeliveryDate, dgsr.ItemId


update ltr
    set ltr.ReturnDate = t.CreationDate
    ,   ltr.StateTagsId = t.StateTagId
from #latestTraceabilityRecord ltr
inner join AssetsTraceability t on ltr.AssetsTraceabilityId = t.id


-- Consolida toda la informaci贸n.
if object_id('tempdb..#resultReport') is not null
    drop table #resultReport

create table #resultReport
(
        DeliveryDate datetime not null
    ,   EmployeeDocumentNumber varchar(10) not null
    ,   EmployeeFirstName nvarchar(255) not null
    ,   EmployeeLastName nvarchar(255) not null
    ,   ArticleCompleteDescription nvarchar(100) not null
    ,   ModelDescription nvarchar(255) not null
    ,   Epc nvarchar(255) not null
	,   Remarks varchar(max) null
)

create index resultReportIX1 on #resultReport ([DeliveryDate])

insert into #resultReport
select  dgsr.[DeliveryDate]
    ,   dgsr.[EmployeeDocumentNumber]
    ,   dgsr.[EmployeeFirstName]
    ,   dgsr.[EmployeeLastName]
    ,   iacd.[ArticleCompleteDescription]
    ,   iacd.[model] [ModelDescription]
    ,   dgsr.[Epc]
	,   dgsr.[Remarks]
from #deliveryGuideSR dgsr
inner join #itemArtCompleteDescription iacd on dgsr.articleId = iacd.articleId
left join #latestTraceabilityRecord ltr on  dgsr.ItemId = ltr.ItemId 
                                        and dgsr.DeliveryGuideId = ltr.DeliveryGuideId
where ltr.ReturnDate is null

select  rr.[DeliveryDate]
    ,   rr.[EmployeeDocumentNumber]
    ,   rr.[EmployeeFirstName]
    ,   rr.[EmployeeLastName]
    ,   rr.[ArticleCompleteDescription]
    ,   rr.[ModelDescription]
    ,   rr.[Epc]
	,   rr.[Remarks]
from #resultReport rr
order by    case when @sortColumn = 'DeliveryDate' and @sortOrder = 'asc' then rr.[DeliveryDate] end asc,
            case when @sortColumn = 'DeliveryDate' and @sortOrder = 'desc' then rr.[DeliveryDate] end desc,
            case when @sortColumn = 'EmployeeDocumentNumber' and @sortOrder = 'asc' then rr.[EmployeeDocumentNumber] end asc,
            case when @sortColumn = 'EmployeeDocumentNumber' and @sortOrder = 'desc' then rr.[EmployeeDocumentNumber] end desc,
            case when @sortColumn = 'EmployeeFirstName' and @sortOrder = 'asc' then rr.[EmployeeFirstName] end asc,
            case when @sortColumn = 'EmployeeFirstName' and @sortOrder = 'desc' then rr.[EmployeeFirstName] end desc,
            case when @sortColumn = 'EmployeeLastName' and @sortOrder = 'asc' then rr.[EmployeeLastName] end asc,
            case when @sortColumn = 'EmployeeLastName' and @sortOrder = 'desc' then rr.[EmployeeLastName] end desc,
            case when @sortColumn = 'ArticleCompleteDescription' and @sortOrder = 'asc' then rr.[ArticleCompleteDescription] end asc,
            case when @sortColumn = 'ArticleCompleteDescription' and @sortOrder = 'desc' then rr.[ArticleCompleteDescription] end desc,
            case when @sortColumn = 'Epc' and @sortOrder = 'asc' then rr.[Epc] end asc,
            case when @sortColumn = 'Epc' and @sortOrder = 'desc' then rr.[Epc] end desc,
            case when @sortColumn = 'ModelDescription' and @sortOrder = 'asc' then rr.[ModelDescription] end asc,
            case when @sortColumn = 'ModelDescription' and @sortOrder = 'desc' then rr.[ModelDescription] end desc
offset (@pageNumber*@pageSize) rows
fetch next @pageSize rows only;
set @rc = @@error

set nocount off;

return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[exception_throw]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[exception_throw]
as
begin
  -- Fuente: http://www.sommarskog.se/error_handling/Part1.html
  declare @errmsg nvarchar(2048)
        , @severity tinyint
        , @state tinyint
        , @errno int
        , @proc sysname
        , @lineno int

  select @errmsg = error_message()
      , @severity = error_severity()
      , @state  = error_state()
      , @errno = error_number()
      , @proc   = error_procedure()
      , @lineno = error_line()

  if @errmsg NOT LIKE '***%'
  begin
  -- El prop贸sito de esta instrucci贸n SELECT es formatear un mensaje de error 
  -- que pasamos a RAISERROR, y que incluye toda la informaci贸n en el mensaje 
  -- de error original que no podemos inyectar directamente en RAISERROR. 
  -- Necesitamos dar un tratamiento especial al nombre del procedimiento, ya 
  -- que ser谩 NULO para los errores que ocurren en lotes ad-hoc o en SQL 
  -- din谩mico.

    select @errmsg = '*** ' + coalesce(quotename(@proc), '<dynamic SQL>') 
                            + ', Line ' + ltrim(str(@lineno)) 
                            + '. Errno ' + ltrim(str(@errno)) + ': ' + @errmsg

  -- El mensaje de error formateado comienza con tres asteriscos. Esto tiene 
  -- dos prop贸sitos: 
  -- 1) Podemos ver directamente que se trata de un mensaje reubicado de un 
  -- controlador CATCH. 
  -- 2) Esto hace posible que error_handler_sp filtre los errores que ha vuelto
  --    a plantear una vez o m谩s con la condici贸n NOT LIKE '***%' para evitar 
  --    que los mensajes de error se modifiquen por segunda vez.
  end
  raiserror('%s', @severity, @state, @errmsg)
end--procedure
GO
/****** Object:  StoredProcedure [dbo].[GetItemForRest]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetItemForRest]
(
    @epc nvarchar(30),
	@LocationOriginId int,
	@shippingGuideId int null
)
as
begin
   SET NOCOUNT ON;
	;with Groups as(
		select count(sgd.id) as countSGD, sg.ShippingNumber as ShippingNumber, sg.ShippingGuideStatusId as Status,sgd.PackageDetailId as PId from ShippingGuideDetail sgd
					inner join ShippingGuide sg on sgd.ShippingGuideId = sg.Id
					left join PackageDetail pd on sgd.PackageDetailId = pd.Id
					where sgd.ItemId = (select Id from Item where EPC = @epc) and sg.ShippingGuideStatusId in (1,2,3,7,8,9,10,12,13,14,16,17,18,19)
					and sg.LocationDestinationId in (select l.Id from [Location] l where l.LocationInterna != 1)
					and sg.LocationOriginId = @LocationOriginId
					and (pd.DefaultForModel = 0 or pd.Id is null)
					and @shippingGuideId is not null
					and (select top 1 LocationOriginId from ShippingGuide where Id = @shippingGuideId) = @LocationOriginId
					and @shippingGuideId != sg.Id
					group by sg.ShippingNumber, sg.ShippingGuideStatusId,sgd.PackageDetailId
					union
					select count(t.Id) as countSGD, t.ShippingNumber as ShippingNumber, t.ShippingGuideStatusId as Status, t.PackageID as PId
					from (select top 1 sg.ShippingNumber as ShippingNumber, sgi.Assign, sgi.Id, sg.ShippingGuideStatusId, sgi.PackageID  from ShippingGuideIntermediate sgi
					inner join ShippingGuide sg on sgi.ShippingGuideID = sg.Id
					where sgi.IdItem = (select Id from Item where EPC = @epc)
					and sgi.DestinationLocationID in (select l.Id from [Location] l where l.LocationInterna != 1)
					and sgi.OriginLocationID = @LocationOriginId
					and sg.ShippingGuideStatusId in (1,2,3,7,8,9,10,12,13,14,16,17,18,19)
					and @shippingGuideId is not null
					and (select top 1 LocationOriginId from ShippingGuide where Id = @shippingGuideId) = @LocationOriginId
					and @shippingGuideId != sg.Id
					order by sgi.Id desc) as t
					where t.Assign = 1
					group by t.ShippingNumber,t.ShippingGuideStatusId,t.PackageID
		)
	   select (
	   SELECT
		ItemEPC.Id, 
	   ItemEPC.LocationId, 
	   ItemEPC.StateTagsId, 
	   ItemEPC.ShippingGuideErrorTypeId,
	   ItemEPC.ArticleId, 
	   ItemEPC.Description, 
	   BrandLocation.BrandLocationId id, 
	   ItemEPC.ModelId, 
	   ItemEPC.CodArt, 
	   ItemEPC.Code, 
	   ItemEPC.ColorArtDescription, 
	   ItemEPC.SizeArtDescription,
	   ItemEPC.ArticleCompleteDescription,
	   ItemEPC.ErrorType,
	   ItemEpc.ShippingGuideStatusPerNumber,
	   ItemEPC.PackageDetailIdInOtherGuide,
	   ItemEPC.IsPrimary,
	   ItemEPC.IsSecondary
	   from (
	   SELECT        
	   Item.Id, 
	   Item.LocationId,
	   Item.StateTagsId,
	   /*(	
	   	    select sged.IdShippingGuideTypeError
			from ShippingGuideError sge
			inner join ShippingGuideErrorDetail sged on sge.Id = sged.IdShippingGuideError and sged.ItemId = Item.Id
			where  sge.IdShippingGuide =  @shippingGuideId
	   ) as ShippingGuideErrorTypeId,*/
	   NULL as ShippingGuideErrorTypeId,
	   Item.ArticleId, 
	   Model.Description, 
	   Model.Id ModelId, 
	   Article.CodArt, 
	   Brand.Code, 
	   '' ColorArtDescription, 
	   '' SizeArtDescription,
	   brandid,
	   NULL AS ArticleCompleteDescription,
		case 
			when (select sum(g.countSGD) from Groups g) = 0 then Item.StateTagsId 
			when (select sum(g.countSGD) from Groups g) is null then Item.StateTagsId 
			else 7 
			end ErrorType,
		(
			Select SUBSTRING( 
			( 
				SELECT ',' + g.ShippingNumber + '-' + CONVERT(varchar,g.Status) AS 'data()' from
				(select * from Groups) g FOR XML PATH('') 
			), 2 , 9999)
		) ShippingGuideStatusPerNumber,
		(
			select top 1 g.PId from Groups g where g.PId is not null and g.PId != 0
		) PackageDetailIdInOtherGuide,
		Model.IsPrimary,
		Model.IsSecondary
    
	FROM            
	Item 
	INNER JOIN Article ON Item.ArticleId = Article.Id 
	INNER JOIN Model ON Article.ModelId = Model.Id 
	INNER JOIN Brand ON Article.BrandId = Brand.Id
	where Item.Epc = @epc
	and Item.Excluded = 0
	) ItemEPC 
	INNER JOIN
	(select distinct LocationId BrandLocationId, BrandId from BrandLocation)BrandLocation ON ItemEPC.brandid = BrandLocation.BrandId
	for xml auto, ROOT('ItemREST') ) XML

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[Insert_Remote_ShippingGuide]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[Insert_Remote_ShippingGuide]


		@GenerateDate [datetime],
		@LocationOriginId [int],
		@LocationDestinationId [int],
		@Version [int],
		@CreationUserAccountId [int],
		@CreationDate [datetime],
		@ModifiedUserAccountId [int],
		@ModifiedDate [datetime],
		@ShippingNumber [varchar] (20),
		@Remarks [varchar] (150),
		@IsManual [bit],
		@ShippingDate [datetime],
		@ReceptionDate [datetime],
		@ShippingGuideMovementTypeId [int]
AS
BEGIN

if exists (select * from ShippingGuide where ShippingNumber = @ShippingNumber )
begin

update  ShippingGuide 
		set GenerateDate = @GenerateDate,
		LocationOriginId =@LocationOriginId,
		LocationDestinationId =@LocationDestinationId,
		Version =@Version,
		CreationUserAccountId=@CreationUserAccountId,
		CreationDate =@CreationDate,
		ModifiedUserAccountId = @ModifiedUserAccountId,
		ModifiedDate =@ModifiedDate,
		ShippingNumber =@ShippingNumber,
		Remarks =@Remarks,
		IsManual =@IsManual,
		ShippingDate =@ShippingDate,
		ReceptionDate =@ReceptionDate,
		ShippingGuideMovementTypeId =@ShippingGuideMovementTypeId
		where ShippingNumber = @ShippingNumber;

		return (select top 1 Id from ShippingGuide where ShippingNumber = @ShippingNumber);

		end
else
begin
	INSERT INTO [dbo].[ShippingGuide]
    (
		GenerateDate,
		LocationOriginId,
		LocationDestinationId,
		Version,
		CreationUserAccountId,
		CreationDate,
		ModifiedUserAccountId,
		ModifiedDate,
		ShippingNumber,
		Remarks,
		IsManual,
		ShippingDate,
		ReceptionDate,
		ShippingGuideMovementTypeId
	)
    VALUES
    (
		@GenerateDate ,
		@LocationOriginId ,
		@LocationDestinationId ,
		@Version ,
		@CreationUserAccountId ,
		@CreationDate ,
		@ModifiedUserAccountId ,
		@ModifiedDate ,
		@ShippingNumber ,
		@Remarks ,
		@IsManual ,
		@ShippingDate ,
		@ReceptionDate ,
		@ShippingGuideMovementTypeId
	)

	RETURN SCOPE_IDENTITY();
	end
END
GO
/****** Object:  StoredProcedure [dbo].[item_getStockReportByStatus]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[item_getStockReportByStatus]
(
    @locationIds varchar(8000)
  , @childLocationIds varchar(8000)
  , @excludeChildLocations bit
  , @stateTagIds varchar(8000)
  , @idleDay int
  , @pageNumber int
  , @pageSize int
  , @sortColumn varchar(20)
  , @sortOrder varchar(4)
  , @totalRowCount int output
)
with recompile
as
begin
    declare @rc int
    declare @sDelimiter varchar(1)
    declare @limitDate datetime

    set @sDelimiter = ','


    -- Calcula d?as en desuso
    if  (@idleDay is not null)
    begin
        set @limitDate = DATEADD(dd, -@idleDay, CONVERT(date, getdate()));
    end --if

    set nocount on;


    -- Calcula las ubicaciones (Padres e Hijas).

    if object_id('tempdb..#locationIds') is not null
        drop table #locationIds

    create table #locationIds
    (
        locationId int
    )

    insert into #locationIds
    select item 
        from [dbo].[fnSplit] (@locationIds, @sDelimiter)


    -- Calcula las ubicaciones hijas.
    if @excludeChildLocations = 0
    begin
        insert into #locationIds
        select item 
            from [dbo].[fnSplit] (@childLocationIds, @sDelimiter)
    end -- if

    -- Calcula los estados de las prendas.
    if object_id('tempdb..#stateTagIds') is not null
        drop table #stateTagIds

    create table #stateTagIds
    (
        stateTagId int
    )

    insert into #stateTagIds
    select item 
        from [dbo].[fnSplit] (@stateTagIds, @sDelimiter)


    -- 1. Filtra las prendas
    if object_id('tempdb..#itemsr') is not null
        drop table #itemsr

    create table #itemsr
    (
            itemId int not null 
        ,   epc nvarchar(30) not null
        ,   stateTagId int null
        ,   stateTag nvarchar(50) not null
        ,   lastdateMove datetime not null
        ,   deletedDate datetime null
        ,   articleId int not null
        ,   modelId int not null
        ,   modelDescription nvarchar(255) not null
        ,   price decimal(10,2) not null
        ,   locationId int not null
        ,   locationName nvarchar(50) not null
        ,   articleCompleteDescription nvarchar(255) null
        ,   documentNumber nvarchar(10) null
        ,   firstName nvarchar(100) null
        ,   lastName nvarchar(100) null
        ,   primary key(itemId)
    )
    insert into #itemsr
    select  i.[Id] [ItemId]
        ,   i.[Epc]
        ,   i.[StateTagsId]
        ,   st.[Name]
        ,   i.[LastDateMove]
        ,   i.[DeletedDate]
        ,   i.[ArticleId]
        ,   a.[ModelId]
        ,   m.[Description]
        ,   convert(decimal(10,2), m.[PriceUnit]) [Price]
        ,   l.[Id] [LocationId]
        ,   l.[Name]
        ,   null
        ,   null
        ,   null
        ,   null
        from [item] i
        inner join [StateTags] st on i.StateTagsId = st.Id
        inner join [Article] a on i.ArticleId = a.Id
        inner join [Model] m on a.ModelId = m.Id
        inner join [Location] l on i.LocationId = l.Id
    where i.[Epc] is not null
    and
    (
        @locationIds is null 
        or 
        (
			i.LocationId in ( select locationId from #locationIds)
			and 
			(
				(@excludeChildLocations = 1 and 
				(l.ParentId is null or ParentId in (select Id from Location l2 where l2.ParentId is null))) or (@excludeChildLocations = 0)
			)
        )
    )
    and
    (
        @stateTagIds is null 
        or 
        i.StateTagsId in
        (
        select stateTagId
            from #stateTagIds
        )
    )
    and
    (
        @idleDay is null
        or 
        i.LastDateMove <= @limitDate
    )

    --  2. Calcula la descripci?n del Articulo
    if object_id('tempdb..#itemArtCompleteDescription') is not null
        drop table #itemArtCompleteDescription

    create table #itemArtCompleteDescription
    (
            model nvarchar(255) not null
        ,   category nvarchar(255) not null
        ,   articleId int not null
        ,   articleCompleteDescription nvarchar(255) not null
    )

    create index itemArtCompleteDescriptionIX1 on #itemArtCompleteDescription (articleId)

    insert into #itemArtCompleteDescription
    select  distinct
            m.description model
        ,   isnull(c.description,'') category
        ,   a.id articleId
        ,   a.codArt + ' - ' + m.description + ' - ' + b.code +
            case 
                when (ca.Generic = 0 and s.Generic = 0) then ' (Color: ' + ca.Description + ', Talle: ' + s.Description + ')'
                when (ca.Generic = 0 and s.Generic = 1) then ' (Color: ' + ca.Description + ')'
                when (ca.Generic = 1 and s.Generic = 0) then ' (Talle: ' + s.Description + ')'
                when (ca.Generic = 1 and s.Generic = 1) then ''
            end [articleCompleteDescription]
    from #itemsr i
    inner join [Article] a on i.ArticleId = a.id
    inner join [Model] m on a.modelId = m.id
    left join [Category] c on m.categoryId = c.id
    inner join [Brand] b on a.brandId = b.id
    inner join [ColorArt] ca on a.ColorArtId = ca.id
    inner join [Size] s on a.SizeId = s.id


    -- 3a. Para prendas en estado 'Entregada' calcula la ?ltima entrega
    if object_id('tempdb..#lastDeliveryGuide0') is not null
        drop table #lastDeliveryGuide0

    create table #lastDeliveryGuide0
    (
            deliveryGuideId int not null
        ,   itemId int
    )

    create index lastDeliveryGuide0IX1 on #lastDeliveryGuide0 ([itemId])

    insert into #lastDeliveryGuide0
    select  max(dg.Id) deliveryGuideId
        ,   i.itemId
    from #itemsr i
    inner join DeliveryGuideDetail dgd on i.ItemId = dgd.ItemId
    inner join DeliveryGuide dg on dgd.DeliveryGuideId = dg.id
    where i.[stateTagId] = 6 -- Entregada
    group by i.itemId


    -- 3b. Para prendas en estado 'Entregada' a partir de la ?ltima entrega calcula el empleado.
    if object_id('tempdb..#employee0') is not null
        drop table #employee0

    create table #employee0
    (
            documentNumber nvarchar(10) not null
        ,   firstName nvarchar(100) not null
        ,   lastName nvarchar(100) not null
        ,   itemId int
    )

    create index employee0IX1 on #employee0 ([itemId])

    insert into #employee0
    select  e.DocumentNumber
        ,   e.FirstName
        ,   e.LastName
        ,   ldg.itemId
    from #lastDeliveryGuide0 ldg
    inner join DeliveryGuide dg on ldg.DeliveryGuideId = dg.Id 
    inner join Employee e on dg.EmployeeId = e.id

    -- 3c. Para prendas en estado 'Eliminada' calcula el estado previo.
    if object_id('tempdb..#previousStatus') is not null
        drop table #previousStatus

    create table #previousStatus
    (
            previousAssetsTraceabilityId int
        ,   itemId int
    )

    create index previousStatusIX1 on #previousStatus ([itemId])

    insert into #previousStatus
    select  max(t.id) previousAssetsTraceabilityId
        ,   i.itemId
      from #itemsr i
      inner join 
      (
        select  i.itemId
            ,   max(t.id) maxAssetsTraceabilityId
          from #itemsr i
          inner join AssetsTraceability t on i.itemId = t.ItemId
          where i.stateTagId = 4 -- Eliminada
          group by i.itemId
      ) lc on i.itemId = lc.itemId
      inner join AssetsTraceability t on i.itemId = t.ItemId and t.id < lc.maxAssetsTraceabilityId
      where i.stateTagId = 4 -- Eliminada
      group by i.itemId


    -- 3d. Para prendas en estado 'Eliminada' y estado previo 'Entregada' calcula la ?ltima entrega
    if object_id('tempdb..#lastDeliveryGuide1') is not null
        drop table #lastDeliveryGuide1

    create table #lastDeliveryGuide1
    (
            deliveryGuideId int not null
        ,   itemId int
    )

    create index lastDeliveryGuide1IX1 on #lastDeliveryGuide1 ([itemId])

    insert into #lastDeliveryGuide1
    select  max(dg.Id) deliveryGuideId
        ,   t.itemId
    from 
    (
      select  t.ItemId
            , t.StateTagId
          from #previousStatus ps
          inner join AssetsTraceability t on ps.previousAssetsTraceabilityId = t.id
      where t.StateTagId = 6 -- entregada
    ) t
    inner join DeliveryGuideDetail dgd on t.ItemId = dgd.ItemId
    inner join DeliveryGuide dg on dgd.DeliveryGuideId = dg.id
    group by t.itemId


    -- 3e. Para prendas en estado 'Eliminada' y estado previo 'Entregada' a partir de la ?ltima entrega calcula el empleado.
    insert into #employee0
    select  e.DocumentNumber
        ,   e.FirstName
        ,   e.LastName
        ,   ldg.itemId
    from #lastDeliveryGuide1 ldg
    inner join DeliveryGuide dg on ldg.DeliveryGuideId = dg.Id 
    inner join Employee e on dg.EmployeeId = e.id


    -- N. Consolida toda la informaci?n.
    if object_id('tempdb..#stockReport') is not null
        drop table #stockReport

    create table #stockReport
    (
            [Epc] varchar(30) not null
        ,   [StateTag] nvarchar(50)
        ,   [LastDateMove] datetime not null
        ,   [DeletedDate] datetime null
        ,   [ModelDescription] nvarchar(255)
        ,   [CategoryDescription] nvarchar(255)
        ,   [Price] decimal(10,2) not null
        ,   [ArticleCompleteDescription] nvarchar(255)
        ,   [LocationName] nvarchar(255)
        ,   [DocumentNumber] nvarchar(10) null
        ,   [FirstName] nvarchar(100) null
        ,   [LastName] nvarchar(100) null
    )

    create index stockReportIX1 on #stockReport ([LastDateMove])

    insert into #stockReport
    select  i.epc [Epc]
        ,   i.stateTag [StateTag]
        ,   i.lastdateMove [LastDateMove]
        ,   i.deletedDate [DeletedDate]
        ,   iacd.model [ModelDescription]
        ,   iacd.category [CategoryDescription]
        ,   i.price [Price]
        ,   iacd.articleCompleteDescription [ArticleCompleteDescription]
        ,   i.[locationName] [LocationName]
        ,   e0.documentNumber
        ,   e0.firstName
        ,   e0.lastName
    from #itemsr i
    inner join #itemArtCompleteDescription iacd on i.articleId = iacd.articleId
    left join #employee0 e0 on i.itemId = e0.itemId

    select @totalRowCount = @@ROWCOUNT


    -- N+1. Aplica paginaci?n sobre el resultado obtenido.
    -- https://blog.sqlauthority.com/2017/02/26/pagination-sql-server-interview-question-week-111/
    select  p.[Epc]
        ,   p.[StateTag]
        ,   p.[LastDateMove]
        ,   p.[DeletedDate]
        ,   p.[ModelDescription]
        ,   p.[CategoryDescription]
        ,   p.[Price]
        ,   p.[ArticleCompleteDescription]
        ,   p.[LocationName]
        ,   p.[DocumentNumber]
        ,   p.[FirstName]
        ,   p.[LastName]
    from #stockReport p
    order by    case when @sortColumn = '0' and @sortOrder = 'asc' then p.[LastDateMove] end asc,
                case when @sortColumn = '0' and @sortOrder = 'desc' then p.[LastDateMove] end desc, 
                case when @sortColumn = '1' and @sortOrder = 'asc' then p.[Epc] end asc,
                case when @sortColumn = '1' and @sortOrder = 'desc' then p.[Epc] end desc,
                case when @sortColumn = '2' and @sortOrder = 'asc' then p.[CategoryDescription] end asc,
                case when @sortColumn = '2' and @sortOrder = 'desc' then p.[CategoryDescription] end desc,
                case when @sortColumn = '3' and @sortOrder = 'asc' then p.[ModelDescription] end asc,
                case when @sortColumn = '3' and @sortOrder = 'desc' then p.[ModelDescription] end desc,
                case when @sortColumn = '4' and @sortOrder = 'asc' then p.[ArticleCompleteDescription] end asc,
                case when @sortColumn = '4' and @sortOrder = 'desc' then p.[ArticleCompleteDescription] end desc,
                case when @sortColumn = '5' and @sortOrder = 'asc' then p.[Price] end asc,
                case when @sortColumn = '5' and @sortOrder = 'desc' then p.[Price] end desc,
                case when @sortColumn = '6' and @sortOrder = 'asc' then p.[StateTag] end asc,
                case when @sortColumn = '6' and @sortOrder = 'desc' then p.[StateTag] end desc,
                case when @sortColumn = '7' and @sortOrder = 'asc' then p.[LocationName] end asc,
                case when @sortColumn = '7' and @sortOrder = 'desc' then p.[LocationName] end desc,
                case when @sortColumn = '8' and @sortOrder = 'asc' then p.[DeletedDate] end asc,
                case when @sortColumn = '8' and @sortOrder = 'desc' then p.[DeletedDate] end desc,
                case when @sortColumn = '9' and @sortOrder = 'asc' then p.[DocumentNumber] end asc,
                case when @sortColumn = '9' and @sortOrder = 'desc' then p.[DocumentNumber] end desc,
                case when @sortColumn = '10' and @sortOrder = 'asc' then p.[FirstName] end asc,
                case when @sortColumn = '10' and @sortOrder = 'desc' then p.[FirstName] end desc,
                case when @sortColumn = '11' and @sortOrder = 'asc' then p.[LastName] end asc,
                case when @sortColumn = '11' and @sortOrder = 'desc' then p.[LastName] end desc
  offset (@pageNumber*@pageSize) rows
  fetch next @pageSize rows only;

  set @rc = @@error

  set nocount off;

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[receptionGuide_insertReceptionMovement]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[receptionGuide_insertReceptionMovement]
(
	@idReceptionGuide int,
	@idLocationOrigin int,
	@permissionRequired bit,
	@idUser int,
	@idMovementType int
)
as
begin
declare @rc int
  declare @errorMessage varchar(max)

  set nocount on;

  -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/language-elements/try-catch-transact-sql?view=sql-server-2017
  -- Causar� que la transacci髇 no se pueda comprometer cuando se produce la violaci髇 de la restricci髇.
  set xact_abort on;

  begin try
	
	begin transaction

  if object_id('tempdb..#epcs') is not null
    drop table #epcs

  create table #epcs
  (
    epc varchar(50) collate SQL_Latin1_General_CP1_CI_AS
  )

  if object_id('tempdb..#newEpcs') is not null
    drop table #newEpcs

  create table #newEpcs
  (
    epc varchar(50) collate SQL_Latin1_General_CP1_CI_AS
  )

	declare @idLocationDestination int
	declare @amhIds table(ahmId int)
	declare @amhId int
	declare @amiIds table(amiId int, articleId int)

	select @idLocationDestination = (select LocationDestinationId from ReceptionGuide where Id = @idReceptionGuide)

	insert into AssetsMovementsHeader(DestinationLocationId,SourceLocationId,PermissionRequired,AssetMovementTypeId,ReceptionGuideId,Version,CreationUserAccountId,CreationDate)
	output inserted.Id into @amhIds
	values (@idLocationDestination,@idLocationOrigin,@permissionRequired,@idMovementType,@idReceptionGuide,1,@idUser,GETDATE())

	select @amhId = (select top 1 * from @amhIds)

	--INSERTAR PRENDAS SIN CHIP
	insert into AssetsMovementsItems(ArticleId,Quantity,AssetsMovementHeaderId,Version,CreationUserAccountId,CreationDate,ModelId)
		output inserted.Id,inserted.ArticleId into @amiIds(amiId,articleId)
		select rgd.ArticleId,sum(rgd.Quantity),@amhId,1,@idUser,GETDATE(),rgd.ModelId
		from ReceptionGuideDetail rgd 
		where rgd.ReceptionGuideId = @idReceptionGuide --and rgd.ItemId is not null
		group by rgd.ArticleId,rgd.ModelId


	insert into AssetsMovementsItemsDetail(ItemId,ArticleId,AssetsMovementsItemId,Version,CreationUserAccountId,CreationDate)
		select rgd.ItemId, rgd.ArticleId, amiIds.amiId,1,@idUser,GETDATE()
		from ReceptionGuideDetail rgd 
		left join @amiIds amiIds on amiIds.articleId = rgd.ArticleId
		where rgd.ReceptionGuideId = @idReceptionGuide and rgd.ItemId is not null

	commit transaction
    set @rc = @@error;

  end try

  begin catch
    -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/functions/error-number-transact-sql?view=sql-server-2017
    set @rc = ERROR_NUMBER()
    set @errorMessage = ERROR_MESSAGE()
    -- Valores de XACT_STATE:
      -- Si es 1, la transacci髇 se puede confirmar.
      -- Si es -1, la transacci髇 no se puede confirmar y se debe revertir.
      -- XACT_STATE = 0 no hay transacci髇 para confimar o revertir.

    -- Verifica si la transacci髇 se debe revertir.
    if (xact_state()) = -1
    begin
        rollback transaction;
    end;

    -- Verifica si la transacci髇 se puede confirmar.
    if (xact_state()) = 1
    begin
        commit transaction;
    end;

    -- WARNING: SGA 30/04/2019. Se burbujea la excepci髇.
    throw @rc, @errorMessage, 1;
    print 'Mensaje: ' + @errorMessage
  end catch

  return @rc
end--procedure
GO
/****** Object:  StoredProcedure [dbo].[receptionGuide_updateItems]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[receptionGuide_updateItems]
(
	@requiredAuthorization bit,
	@idLocationDestination int,
	@epcs varchar(max),
	@newEpcs varchar(max),
	@idUser int,
	@idMovementType int,
	@stateAndLocation bit = 1
)
as
begin
declare @rc int
  declare @errorMessage varchar(max)

  set nocount on;

  set xact_abort on;

  begin try
	
	begin transaction

  if object_id('tempdb..#epcs') is not null
    drop table #epcs

  create table #epcs
  (
    epc varchar(50) collate SQL_Latin1_General_CP1_CI_AS
  )

  if object_id('tempdb..#newEpcs') is not null
    drop table #newEpcs

  create table #newEpcs
  (
    epc varchar(50) collate SQL_Latin1_General_CP1_CI_AS
  )

  declare @laundry bit
  select @laundry = (select Laundry from Location where Id = @idLocationDestination)

  insert into #epcs
  select item  collate SQL_Latin1_General_CP1_CI_AS
    from [dbo].[fnSplit] (@epcs , ',')
	 
  insert into #newEpcs
  select item  collate SQL_Latin1_General_CP1_CI_AS
    from [dbo].[fnSplit] (@newEpcs, ',')

	/*Traza de items existentes con errores*/
	if(@requiredAuthorization = 1)
		insert into AssetsTraceability (ItemId,LocationId,StateTagId, AssetMovementTypeId, ArticleId,Version,CreationUserAccountId,CreationDate)  
		select 
			i.Id, 
			i.LocationId,
			case 
				when @stateAndLocation = 0
				then i.StateTagsId
				else 3
			end, 
			case
				when i.StateTagsId = 4 then 13
				when i.StateTagsId = 2 then 12
				when i.StateTagsId = 5 then 14
				when i.StateTagsId = 1 then 15
			end Movement,
			i.ArticleId,
			1,
			@idUser,
			GETDATE()
		from Item i 
		where i.epc collate SQL_Latin1_General_CP1_CI_AS in (select epc collate SQL_Latin1_General_CP1_CI_AS from #epcs) and i.Epc not in (select epc collate SQL_Latin1_General_CP1_CI_AS from #newEpcs) and i.StateTagsId in (1,2,4,5)

	--Actualizacion de items
	if(@stateAndLocation = 1)
		begin
		update i set 
			LocationId = @idLocationDestination,
			LastDateMove = GETDATE(),
			StateTagsId = 1,
			Excluded = case
						when @laundry = 1 and Excluded = 1 then 0
						else Excluded
					   end,
			Version = Version + 1
		from Item i
		where Epc collate SQL_Latin1_General_CP1_CI_AS in (select epc from #epcs)
			and ((select top 1 tr.AssetMovementTypeId
			from AssetsTraceability tr 
			where tr.ItemId = i.Id 
			order by tr.CreationDate desc) = 23 OR @laundry = 1)
	end

	--Traza de movimiento de recepcion
	insert into AssetsTraceability (ItemId,LocationId,StateTagId, AssetMovementTypeId, ArticleId,Version,CreationUserAccountId,CreationDate)  
	select 
		i.Id, 
		@idLocationDestination,
		case 
			when @stateAndLocation = 0
			then i.StateTagsId
			else 1
		end,
		@idMovementType,
		i.ArticleId,
		1,
		@idUser,
		GETDATE()
	from Item i 
	where i.epc collate SQL_Latin1_General_CP1_CI_AS in (select epc from #epcs)

	commit transaction
    set @rc = @@error;

  end try

  begin catch
    -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/functions/error-number-transact-sql?view=sql-server-2017
    set @rc = ERROR_NUMBER()
    set @errorMessage = ERROR_MESSAGE()
    -- Valores de XACT_STATE:
      -- Si es 1, la transacci髇 se puede confirmar.
      -- Si es -1, la transacci髇 no se puede confirmar y se debe revertir.
      -- XACT_STATE = 0 no hay transacci髇 para confimar o revertir.

    -- Verifica si la transacci髇 se debe revertir.
    if (xact_state()) = -1
    begin
        rollback transaction;
    end;

    -- Verifica si la transacci髇 se puede confirmar.
    if (xact_state()) = 1
    begin
        commit transaction;
    end;

    -- WARNING: SGA 30/04/2019. Se burbujea la excepci髇.
    throw @rc, @errorMessage, 1;
    print 'Mensaje: ' + @errorMessage
  end catch

  return @rc
end--procedure
GO
/****** Object:  StoredProcedure [dbo].[receptionGuide_updateNotReceivedItems]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[receptionGuide_updateNotReceivedItems]
(
	@itemIds varchar(max),
	@stateTagsId int,
	@idMovementType int,
	@idUser int
)
as
begin
declare @rc int
  declare @errorMessage varchar(max)

  set nocount on;

  -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/language-elements/try-catch-transact-sql?view=sql-server-2017
  -- Causar� que la transacci髇 no se pueda comprometer cuando se produce la violaci髇 de la restricci髇.
  set xact_abort on;

  begin try
	
	begin transaction

  if object_id('tempdb..#itemIds') is not null
    drop table #itemIds

  create table #itemIds
  (
    itemId int
  )

  insert into #itemIds
  select item 
    from [dbo].[fnSplit] (@itemIds , ',')

	--Actualizacion de items
	update i set 
		LocationId = LocationId,
		LastDateMove = GETDATE(),
		StateTagsId = @stateTagsId,
		Version = Version + 1
	from Item i
	where Id in (select itemId from #itemIds)
			and (select top 1 tr.AssetMovementTypeId
		from AssetsTraceability tr 
		where tr.ItemId = i.Id 
		order by tr.CreationDate desc) = 23

	--Traza de movimiento de recepcion
	insert into AssetsTraceability (ItemId,LocationId,StateTagId, AssetMovementTypeId, ArticleId,Version,CreationUserAccountId,CreationDate)  
	select 
		i.Id, 
		i.LocationId,
		@stateTagsId, 
		@idMovementType,
		i.ArticleId,
		1,
		@idUser,
		GETDATE()
	from Item i 
	where i.Id in (select itemId from #itemIds)

	commit transaction
    set @rc = @@error;

  end try

  begin catch
    -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/functions/error-number-transact-sql?view=sql-server-2017
    set @rc = ERROR_NUMBER()
    set @errorMessage = ERROR_MESSAGE()
    -- Valores de XACT_STATE:
      -- Si es 1, la transacci髇 se puede confirmar.
      -- Si es -1, la transacci髇 no se puede confirmar y se debe revertir.
      -- XACT_STATE = 0 no hay transacci髇 para confimar o revertir.

    -- Verifica si la transacci髇 se debe revertir.
    if (xact_state()) = -1
    begin
        rollback transaction;
    end;

    -- Verifica si la transacci髇 se puede confirmar.
    if (xact_state()) = 1
    begin
        commit transaction;
    end;

    -- WARNING: SGA 30/04/2019. Se burbujea la excepci髇.
    throw @rc, @errorMessage, 1;
    print 'Mensaje: ' + @errorMessage
  end catch

  return @rc
end--procedure
GO
/****** Object:  StoredProcedure [dbo].[roadMap_updateItems]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[roadMap_updateItems]
(
	@idShippingGuide int,
	@idUser int,
	@stateAndLocation bit = 1,	
	@itemIds varchar(max) = ''
)
as
begin
declare @rc int
  declare @errorMessage varchar(max)

  set nocount on;

  set xact_abort on;

  begin try
	
	begin transaction

	declare @idLocationDestination int
	declare @idLocationOrigin int
	declare @onlyInItemIds bit

	select @idLocationDestination = (select LocationDestinationId from ShippingGuide where Id = @idShippingGuide)
	select @idLocationOrigin = (select LocationOriginId from ShippingGuide where Id = @idShippingGuide)

	if object_id('tempdb..#itemIds') is not null
    drop table #itemIds

	create table #itemIds
	(
		itemId int
	)


	if(@itemIds is null or @itemIds = '' )
		begin
			set @onlyInItemIds = 0
		end
	else
		begin
			set @onlyInItemIds = 1
			insert into #itemIds
			select item 
			from [dbo].[fnSplit] (@itemIds , ',')
		end

	if(@stateAndLocation = 1)
	begin
		if(select RecepcionManual from Location where Id = @idLocationDestination) = 1 or (select RecepcionRfid from Location where Id = @idLocationDestination) = 1
			begin
				update Item set StateTagsId = 3
				where Id in
				(
				select ItemId
				from ShippingGuideDetail 
				where ShippingGuideId = @idShippingGuide and (@onlyInItemIds = 0 or ItemId in (select itemId from #itemIds))
				--Packs
				union
				select ItemId
				from PackItem
				inner join ShippingGuidePack sgpk on sgpk.PackId = PackItem.PackId
				where ShippingGuideId = @idShippingGuide and (@onlyInItemIds = 0 or ItemId in (select itemId from #itemIds))
				)
			end
		else
			begin 
				update Item set StateTagsId = 1, LocationId = @idLocationDestination 
				where Id in
				(
				select ItemId
				from ShippingGuideDetail 
				where ShippingGuideId = @idShippingGuide and (@onlyInItemIds = 0 or ItemId in (select itemId from #itemIds))
				--Packs
				union				
				select ItemId
				from PackItem
				inner join ShippingGuidePack sgpk on sgpk.PackId = PackItem.PackId
				where ShippingGuideId = @idShippingGuide  and (@onlyInItemIds = 0 or ItemId in (select itemId from #itemIds))
				)
			end
	end

	if(select Laundry from Location where Id = @idLocationOrigin) = 1
		begin 
			update Item set 
				TotalWashCount = ISNULL(TotalWashCount, 0) + 1, 
				CurrentWashCount = ISNULL(CurrentWashCount, 0) + 1,
				LastWashDate = GETDATE()
			where Id in
			(
			select ItemId
			from ShippingGuideDetail 
			where ShippingGuideId = @idShippingGuide and (@onlyInItemIds = 0 or ItemId in (select itemId from #itemIds))
			--Packs
			union				
			select ItemId
			from PackItem
			inner join ShippingGuidePack sgpk on sgpk.PackId = PackItem.PackId
			where ShippingGuideId = @idShippingGuide and (@onlyInItemIds = 0 or ItemId in (select itemId from #itemIds))
			)
		end

	insert into AssetsTraceability (ItemId,LocationId,StateTagId, AssetMovementTypeId, ArticleId,Version,CreationUserAccountId,CreationDate)  
	(
		select ItemId, i.LocationId, i.StateTagsId, 23,i.ArticleId,1,@idUser,GETDATE()
		from ShippingGuideDetail sgd
		inner join Item i on sgd.ItemId = i.Id
		where ShippingGuideId = @idShippingGuide and (@onlyInItemIds = 0 or ItemId in (select itemId from #itemIds))
			
		--Packs
		union				
		select ItemId, i.LocationId, i.StateTagsId, 23,i.ArticleId,1,@idUser,GETDATE()
		from PackItem
		inner join ShippingGuidePack sgpk on sgpk.PackId = PackItem.PackId
		inner join Item i on  ItemId = i.Id
		where ShippingGuideId = @idShippingGuide  and (@onlyInItemIds = 0 or ItemId in (select itemId from #itemIds))
	)

	commit transaction
    set @rc = @@error;

  end try

  begin catch
    -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/functions/error-number-transact-sql?view=sql-server-2017
    set @rc = ERROR_NUMBER()
    set @errorMessage = ERROR_MESSAGE()
    -- Valores de XACT_STATE:
      -- Si es 1, la transacci髇 se puede confirmar.
      -- Si es -1, la transacci髇 no se puede confirmar y se debe revertir.
      -- XACT_STATE = 0 no hay transacci髇 para confimar o revertir.

    -- Verifica si la transacci髇 se debe revertir.
    if (xact_state()) = -1
    begin
        rollback transaction;
    end;

    -- Verifica si la transacci髇 se puede confirmar.
    if (xact_state()) = 1
    begin
        commit transaction;
    end;

    -- WARNING: SGA 30/04/2019. Se burbujea la excepci髇.
    throw @rc, @errorMessage, 1;
    print 'Mensaje: ' + @errorMessage
  end catch

  return @rc
end--procedure
GO
/****** Object:  StoredProcedure [dbo].[shippingGuide_delete]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[shippingGuide_delete]
(
    @shippingGuideId int,
	@userId int
)
as
begin

  declare @rc int
  declare @errorMessage varchar(max)

  set nocount on;

  -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/language-elements/try-catch-transact-sql?view=sql-server-2017
  -- Causar� que la transacci髇 no se pueda comprometer cuando se produce la violaci髇 de la restricci髇.
  set xact_abort on;

  begin try

    begin transaction;

    
	--1. Actualizaci髇 de prendas
	--ShippingGuideErrorDetail
	update ShippingGuideErrorDetail set IdShippingGuideOrigin = null where IdShippingGuideOrigin = @shippingGuideId

	delete sged from ShippingGuideErrorDetail sged
	inner join ShippingGuideError sge on sge.Id = sged.IdShippingGuideError
	where sge.IdShippingGuide = @shippingGuideId
	
	--ShippingGuideError
	delete ShippingGuideError where IdShippingGuide = @shippingGuideId

	--Item
	declare @locationOriginId int
	set @locationOriginId = (select locationOriginId from ShippingGuide where Id = @shippingGuideId)

	update Item set 
		LastDateMove = GETDATE(),
		ModifiedUserAccountId = @userId,
        ModifiedDate = GETDATE(),
        LocationId = @locationOriginId,
        StateTagsId = 1, --En Ubicaci髇
        Version = Version + 1
	where Id in (select ItemId from ShippingGuideDetail where ShippingGuideId = @shippingGuideId)
	

	--2. Generaci髇 de traza
	--AssetsTraceability
	declare @shippingGuideStatus int
	select @shippingGuideStatus = (select ShippingGuideStatusId from ShippingGuide where Id = @shippingGuideId)

	if (@shippingGuideStatus = 3 or @shippingGuideStatus = 12) --Pendiente de Env韔 y Finalizada con Asociaci髇 Concluida
	begin
		insert into AssetsTraceability 
		(
			ArticleId,
			AssetMovementTypeId, 
			ItemId, 
			StateTagId, 
			LocationId, 
			CreationUserAccountId, 
			CreationDate,
			Version
		)
		(
			select sgd.ArticleId, 48 /*Eliminacion de Gu韆*/, sgd.ItemId, 1, @locationOriginId, @userId, GETDATE(), (Version + 1)
			from ShippingGuideDetail sgd 
			where sgd.ShippingGuideId = @shippingGuideId and sgd.ItemId is not null
		)
	end
	
	--3. Elimincaci髇
	--ShippingGuideIntermediate
	delete ShippingGuideIntermediate where ShippingGuideID = @shippingGuideId

	--ShippingGuideIntermediateManual
	delete ShippingGuideIntermediateManual where ShippingGuideID = @shippingGuideId

	--ShippingGuideDetail
	delete ShippingGuideDetail where ShippingGuideId = @shippingGuideId

	--AssetsMovementsItemsDetail
	declare @amhIds table (id int)
	insert @amhIds(id) (select Id from AssetsMovementsHeader amh where amh.ShippingGuideId = @shippingGuideId)

	declare @amiIds table (id int)
	insert @amiIds(id)
		(select(ami.Id) 
		from AssetsMovementsItems ami
		inner join @amhIds amh on ami.AssetsMovementHeaderId = amh.id)

	delete AssetsMovementsItemsDetail 
	where AssetsMovementsItemId in (select * from @amiIds)

	--AssetsMovementsItems
	delete AssetsMovementsItems where Id in (select * from @amiIds)

	--AssetsMovementsHeader
	delete AssetsMovementsHeader where ShippingGuideId = @shippingGuideId

	--AuthorizationLog
	delete AuthorizationLog where ShippingGuideId = @shippingGuideId
	
	--ShippingGuidePack
	delete ShippingGuidePack where ShippingGuideId = @shippingGuideId

	--ShippingGuide
	delete ShippingGuide where Id = @shippingGuideId



    commit transaction;

    set @rc = @@error;

  end try

  begin catch
    -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/functions/error-number-transact-sql?view=sql-server-2017
    set @rc = ERROR_NUMBER()
    set @errorMessage = ERROR_MESSAGE()
    -- Valores de XACT_STATE:
      -- Si es 1, la transacci髇 se puede confirmar.
      -- Si es -1, la transacci髇 no se puede confirmar y se debe revertir.
      -- XACT_STATE = 0 no hay transacci髇 para confimar o revertir.

    -- Verifica si la transacci髇 se debe revertir.
    if (xact_state()) = -1
    begin
        rollback transaction;
    end;

    -- Verifica si la transacci髇 se puede confirmar.
    if (xact_state()) = 1
    begin
        commit transaction;
    end;

    -- WARNING: SGA 30/04/2019. Se burbujea la excepci髇.
    throw @rc, @errorMessage, 1;
    print 'Mensaje: ' + @errorMessage
  end catch

  return @rc

end--procedure
GO
/****** Object:  StoredProcedure [dbo].[shippingGuide_substractItemsInOtherMovements]    Script Date: 7/12/2023 12:34:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[shippingGuide_substractItemsInOtherMovements]
(
   @shippingGuideIdsWithSharedItems varchar(max),
   @shippingGuideId int
)
as
begin
declare @rc int
  declare @errorMessage varchar(max)

  set nocount on;

  -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/language-elements/try-catch-transact-sql?view=sql-server-2017
  -- Causar� que la transacci髇 no se pueda comprometer cuando se produce la violaci髇 de la restricci髇.
  set xact_abort on;

  begin try
	
	begin transaction
	declare @itemIds table (IdItem int primary key not null)
	declare @sgIds table (IdShippingGuide int primary key not null)
	declare @amhIds table (IdAssetsMovementsHeader int primary key not null)
	declare @amiIds table (IdAssetsMovementsItem int primary key not null)
	declare @amidIds table (IdAssetsMovementsItemDetail int primary key not null)

	--falta insertar en itemIds

	insert @sgIds
	select item 
    from [dbo].[fnSplit] (@shippingGuideIdsWithSharedItems, ',')

	print 'insert @sgIds ' + CONVERT(VARCHAR, SYSDATETIME(),121)

	insert @itemIds(IdItem)
	(select IdItem from ShippingGuideIntermediate where Id in 
	(
	select max(sgi.Id) from ShippingGuideIntermediate  sgi
	where sgi.ShippingGuideID = @shippingGuideId 
	group by sgi.IdItem
	) and Assign = 1 and ShippingGuideTypeErrorId = 7)

	print 'insert @itemIds ' + CONVERT(VARCHAR, SYSDATETIME(),121)

	insert @amhIds(IdAssetsMovementsHeader)
	(select amh.Id from AssetsMovementsHeader amh
	where amh.ShippingGuideId in (select IdShippingGuide from @sgIds))

	print 'insert @amhIds ' + CONVERT(VARCHAR, SYSDATETIME(),121)

	insert @amiIds(IdAssetsMovementsItem)
	(select ami.Id from AssetsMovementsItems ami 
	inner join Model m on ami.ModelId = m.Id
	where ami.AssetsMovementHeaderId in (select IdAssetsMovementsHeader from @amhIds) and m.TagsAsig = 1)

	print 'insert @amiIds ' + CONVERT(VARCHAR, SYSDATETIME(),121)

	insert @amidIds(IdAssetsMovementsItemDetail)
	(select amid.Id from AssetsMovementsItemsDetail amid 
	where amid.AssetsMovementsItemId in (select IdAssetsMovementsItem from @amiIds)
	and amid.ItemId in (select IdItem from @itemIds))

	print 'insert @amidIds ' + CONVERT(VARCHAR, SYSDATETIME(),121)

	delete AssetsMovementsItemsDetail where Id in (select IdAssetsMovementsItemDetail from @amidIds)

	print 'delete AssetsMovementsItemsDetail ' + CONVERT(VARCHAR, SYSDATETIME(),121)

	delete ami from AssetsMovementsItems ami 
	where ami.Id in (select IdAssetsMovementsItem from @amiIds) 
		and not exists (select 1 from AssetsMovementsItemsDetail amid where amid.AssetsMovementsItemId = ami.Id)

	print 'delete AssetsMovementsItems ' + CONVERT(VARCHAR, SYSDATETIME(),121)

	delete amh from AssetsMovementsHeader amh
	where amh.Id in (select IdAssetsMovementsHeader from @amhIds)
		and not exists (select 1 from AssetsMovementsItems ami where ami.AssetsMovementHeaderId = amh.Id)

	print 'delete @AssetsMovementsHeader ' + CONVERT(VARCHAR, SYSDATETIME(),121)

	update ami  
	set Quantity = (select count(1) from AssetsMovementsItemsDetail amid where amid.AssetsMovementsItemId = ami.Id)
	from AssetsMovementsItems ami
	where ami.Id in (select IdAssetsMovementsItem from @amiIds)

	print 'update AssetsMovementsItems ' + CONVERT(VARCHAR, SYSDATETIME(),121)
	commit transaction
    set @rc = @@error;

  end try

  begin catch
    -- Referencia: https://docs.microsoft.com/es-es/sql/t-sql/functions/error-number-transact-sql?view=sql-server-2017
    set @rc = ERROR_NUMBER()
    set @errorMessage = ERROR_MESSAGE()
    -- Valores de XACT_STATE:
      -- Si es 1, la transacci髇 se puede confirmar.
      -- Si es -1, la transacci髇 no se puede confirmar y se debe revertir.
      -- XACT_STATE = 0 no hay transacci髇 para confimar o revertir.

    -- Verifica si la transacci髇 se debe revertir.
    if (xact_state()) = -1
    begin
        rollback transaction;
    end;

    -- Verifica si la transacci髇 se puede confirmar.
    if (xact_state()) = 1
    begin
        commit transaction;
    end;

    -- WARNING: SGA 30/04/2019. Se burbujea la excepci髇.
    throw @rc, @errorMessage, 1;
    print 'Mensaje: ' + @errorMessage
  end catch

  return @rc
end--procedure
GO
USE [master]
GO
ALTER DATABASE [LaundryRFID_WithScript] SET  READ_WRITE 
GO
