USE [Container storage costs]
GO
/****** Object:  Table [dbo].[tblCosts]    Script Date: 6/4/2022 11:29:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCosts](
	[cost_code] [int] NULL,
	[Pro_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblFinancial]    Script Date: 6/4/2022 11:29:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblFinancial](
	[Financial_id] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblPortArea]    Script Date: 6/4/2022 11:29:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPortArea](
	[Port_Area_id] [int] IDENTITY(1,1) NOT NULL,
	[Port_Area_Name] [nvarchar](500) NULL,
 CONSTRAINT [PK_tblPortArea] PRIMARY KEY CLUSTERED 
(
	[Port_Area_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblProduct]    Script Date: 6/4/2022 11:29:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblProduct](
	[Product_Id] [int] IDENTITY(1,1) NOT NULL,
	[Product_Owner_Name] [nvarchar](100) NOT NULL,
	[Product_Owner_Tel] [nvarchar](50) NOT NULL,
	[Product_Code] [nvarchar](50) NOT NULL,
	[Product_Port_Area] [nvarchar](500) NULL,
	[Product_Entry_Date] [datetime] NOT NULL,
	[Product_Exit_Date] [datetime] NULL,
	[Product_Is_Cleared] [bit] NOT NULL,
 CONSTRAINT [PK_tblProduct] PRIMARY KEY CLUSTERED 
(
	[Product_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblTariff]    Script Date: 6/4/2022 11:29:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTariff](
	[Tariff_Id] [int] IDENTITY(1,1) NOT NULL,
	[Tariff_Str_Day] [int] NOT NULL,
	[Tariff_end_Day] [int] NULL,
	[Tariff_Cost] [int] NOT NULL,
 CONSTRAINT [PK_tblTariff] PRIMARY KEY CLUSTERED 
(
	[Tariff_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[tblCosts] ([cost_code], [Pro_id]) VALUES (92000000, 1021)
GO
INSERT [dbo].[tblCosts] ([cost_code], [Pro_id]) VALUES (600000, 2021) 
GO
SET IDENTITY_INSERT [dbo].[tblPortArea] ON 
GO
INSERT [dbo].[tblPortArea] ([Port_Area_id], [Port_Area_Name]) VALUES (1007, N'San Diego')
GO
INSERT [dbo].[tblPortArea] ([Port_Area_id], [Port_Area_Name]) VALUES (1008, N'Washington')
GO
SET IDENTITY_INSERT [dbo].[tblPortArea] OFF
GO
SET IDENTITY_INSERT [dbo].[tblProduct] ON 
GO
INSERT [dbo].[tblProduct] ([Product_Id], [Product_Owner_Name], [Product_Owner_Tel], [Product_Code], [Product_Port_Area], [Product_Entry_Date], [Product_Exit_Date], [Product_Is_Cleared]) VALUES (6023, N'Jack carlos', N'857574748', N'23', N'1007', CAST(N'2022-02-02T00:00:00.000' AS DateTime), CAST(N'2022-04-04T00:00:00.000' AS DateTime), 1)
GO
INSERT [dbo].[tblProduct] ([Product_Id], [Product_Owner_Name], [Product_Owner_Tel], [Product_Code], [Product_Port_Area], [Product_Entry_Date], [Product_Exit_Date], [Product_Is_Cleared]) VALUES (6024, N'Lee Yeng', N'242423425', N'63', N'1008', CAST(N'2022-01-02T00:00:00.000' AS DateTime), CAST(N'2022-04-03T00:00:00.000' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[tblProduct] OFF
GO
SET IDENTITY_INSERT [dbo].[tblTariff] ON 
GO
INSERT [dbo].[tblTariff] ([Tariff_Id], [Tariff_Str_Day], [Tariff_end_Day], [Tariff_Cost]) VALUES (1, 1, 10, 0)
GO
INSERT [dbo].[tblTariff] ([Tariff_Id], [Tariff_Str_Day], [Tariff_end_Day], [Tariff_Cost]) VALUES (2, 11, 20, 100000)
GO
INSERT [dbo].[tblTariff] ([Tariff_Id], [Tariff_Str_Day], [Tariff_end_Day], [Tariff_Cost]) VALUES (3, 21, 30, 200000)
GO
INSERT [dbo].[tblTariff] ([Tariff_Id], [Tariff_Str_Day], [Tariff_end_Day], [Tariff_Cost]) VALUES (4, 31, 9999, 500000)
GO
SET IDENTITY_INSERT [dbo].[tblTariff] OFF
GO
ALTER TABLE [dbo].[tblProduct] ADD  CONSTRAINT [DF_tblProduct_Product_Is_Cleared]  DEFAULT ((0)) FOR [Product_Is_Cleared]
GO
/****** Object:  StoredProcedure [dbo].[Sp_CostContainer]    Script Date: 6/4/2022 11:29:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_CostContainer]  @id int 
as 
DECLARE 
@counter int = 0,
@str_date DATETIME,
@end_date DATETIME= getdate(),
@DiffDays int=0,
@q1_str int,
@q1_end int,
@q1_cost int,
@q2_str int,
@q2_end int,
@q2_cost int,
@q3_str int,
@q3_end int,
@q3_cost int,
@q4_str int,
@q4_end int,
@q4_cost int,
@FinalCost int = 0,
@exit_date DATETIME;

set nocount on
BEGIN 

SELECT 
       @q1_str=  tblTariff.Tariff_Str_Day,
	   @q1_end=  tblTariff.Tariff_end_Day,
	   @q1_cost= tblTariff.Tariff_Cost
       FROM 
       tblTariff
	   where
	   tblTariff.Tariff_Id = 1;
	   -----------------------
	   SELECT 
       @q2_str=  tblTariff.Tariff_Str_Day,
	   @q2_end=  tblTariff.Tariff_end_Day,
	   @q2_cost= tblTariff.Tariff_Cost
       FROM 
       tblTariff
	   where
	   tblTariff.Tariff_Id = 2;
	   -----------------------
	   SELECT 
       @q3_str=  tblTariff.Tariff_Str_Day,
	   @q3_end=  tblTariff.Tariff_end_Day,
	   @q3_cost= tblTariff.Tariff_Cost
       FROM 
       tblTariff
	   where
	   tblTariff.Tariff_Id = 3;
	   -----------------------
	   SELECT 
       @q4_str=  tblTariff.Tariff_Str_Day,
	   @q4_end=  tblTariff.Tariff_end_Day,
	   @q4_cost= tblTariff.Tariff_Cost
       FROM 
       tblTariff
	   where
	   tblTariff.Tariff_Id = 4;
		----------------------
SELECT 
       @str_date= tblProduct.Product_Entry_Date,
       @exit_date = tblProduct.Product_Exit_Date
	   FROM 
       tblProduct
	   where
	   tblProduct.Product_Id = @id;
	    


 if(@exit_date is null)
 begin
  SELECT @DiffDays= DATEDIFF(DAY, @str_date,@end_date ); 

  WHILE (@counter < @DiffDays )
begin
	SET @counter = @counter + 1;
  if (@counter >= @q1_str AND @counter<= @q1_end ) 
   BEGIN select @FinalCost = @FinalCost + @q1_cost END
 
  if (@counter >= @q2_str AND @counter<= @q2_end )
    BEGIN select @FinalCost =@FinalCost + @q2_cost END
  
  if (@counter >= @q3_str AND @counter<= @q3_end )
 BEGIN select @FinalCost =@FinalCost + @q3_cost END
  
   if (@counter >= @q4_str AND @counter<= @q4_end )
  BEGIN select @FinalCost =@FinalCost + @q4_cost END
  
  end 
   end
 else
 begin 
 SELECT @DiffDays= DATEDIFF(DAY, @str_date,@exit_date ); 

 WHILE (@counter < @DiffDays )
begin
	SET @counter = @counter + 1;
  if (@counter >= @q1_str AND @counter<= @q1_end ) 
   BEGIN select @FinalCost = @FinalCost + @q1_cost END
 
  if (@counter >= @q2_str AND @counter<= @q2_end )
    BEGIN select @FinalCost =@FinalCost + @q2_cost END
  
  if (@counter >= @q3_str AND @counter<= @q3_end )
 BEGIN select @FinalCost =@FinalCost + @q3_cost END
  
   if (@counter >= @q4_str AND @counter<= @q4_end )
  BEGIN select @FinalCost =@FinalCost + @q4_cost END
  
END
end
print(@FinalCost);
return(@FinalCost);

END
GO
