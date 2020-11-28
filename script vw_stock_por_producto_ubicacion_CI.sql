USE [IMS4MB_IDEALSA_PRD]
GO

/****** Object:  View [dbo].[VW_Stock_Por_Producto_Ubicacion_CI]    Script Date: 27/11/2020 18:46:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_Stock_Por_Producto_Ubicacion_CI]
AS
SELECT        dbo.producto_bodega.IdBodega, dbo.propietarios.IdPropietario, dbo.propietario_bodega.IdPropietarioBodega, dbo.producto.IdProducto, dbo.producto_bodega.IdProductoBodega, dbo.stock.IdStock, 
                         dbo.stock.IdUbicacion_anterior, dbo.unidad_medida.IdUnidadMedida, dbo.stock.IdProductoEstado, dbo.stock.IdPresentacion, dbo.stock.IdRecepcionEnc, dbo.propietarios.nombre_comercial AS Propietario, dbo.producto.codigo, 
                         dbo.producto.codigo_barra AS Barra, dbo.producto.nombre, dbo.unidad_medida.Nombre AS UnidadMedida, dbo.producto_presentacion.nombre AS Presentacion, dbo.stock.lote, dbo.stock.fecha_ingreso AS Ingreso, 
                         dbo.stock.fecha_vence AS Vence, dbo.stock.cantidad AS Cantidad_UMBas, SUM(ISNULL(dbo.stock_res.cantidad, 0)) AS CantidadReservadaUmBas, dbo.stock.cantidad - ISNULL(SUM(dbo.stock_res.cantidad), 0) 
                         AS Disponible_UMBas, dbo.stock.peso, dbo.Nombre_Completo_Ubicacion(dbo.stock.IdUbicacion, dbo.stock.IdBodega) AS UbicacionCompleta, dbo.producto_estado.dañado, dbo.producto_presentacion.factor, 
                         dbo.producto_estado.utilizable AS EstadoUtilizable, dbo.stock.IdUbicacion, dbo.stock.lic_plate, dbo.stock.serial, dbo.stock.añada, dbo.producto.IdIndiceRotacion, dbo.producto_presentacion.alto, 
                         dbo.producto_presentacion.largo, dbo.producto_presentacion.ancho, dbo.bodega_ubicacion.IdTramo, dbo.bodega_ubicacion.ancho AS Ancho_ubicacion, dbo.bodega_ubicacion.largo AS Largo_ubicacion, 
                         dbo.bodega_ubicacion.alto AS Alto_ubicacion, dbo.indice_rotacion.Descripcion AS IndiceRotacion, dbo.producto.existencia_min AS Existencia_min_umbas, dbo.producto.existencia_max AS Existencia_max_umbas, 
                         dbo.producto.costo, dbo.producto_presentacion.MinimoExistencia AS Existencia_min_pres, dbo.producto_presentacion.MaximoExistencia AS Existencia_max_pres, dbo.stock.atributo_variante_1, 
                         dbo.bodega_ubicacion.IdUbicacion AS IdUbicacionActual, dbo.bodega_ubicacion.nivel AS Ubicacion_Nivel, dbo.bodega_ubicacion.indice_x AS Ubicacion_Indice_X, dbo.bodega_ubicacion.descripcion AS Ubicacion_Nombre, 
                         dbo.bodega_tramo.descripcion AS Ubicacion_Tramo, ISNULL(dbo.motivo_devolucion.Nombre, 'N/A') AS MotivoDevolucion, ISNULL(dbo.trans_oc_pol.NoPoliza, 'N/D') AS NoPoliza, dbo.producto_clasificacion.IdClasificacion, 
                         dbo.producto_familia.IdFamilia, dbo.cliente_tiempos.Dias_Local, dbo.cliente_tiempos.Dias_Exterior, dbo.cliente_tiempos.IdCliente, CASE WHEN DATEDIFF(DAY, GETDATE(), dbo.stock.fecha_vence) 
                         >= dbo.cliente_tiempos.Dias_Local OR
                         DATEDIFF(DAY, GETDATE(), dbo.stock.fecha_vence) >= dbo.cliente_tiempos.Dias_Exterior THEN 'Si' ELSE 'No' END AS Aplica, dbo.producto_estado.nombre AS Estado, dbo.stock_res.IdPicking, dbo.stock_res.IdPedido
FROM            dbo.producto_familia INNER JOIN
                         dbo.cliente_tiempos INNER JOIN
                         dbo.producto_clasificacion ON dbo.cliente_tiempos.IdClasificacion = dbo.producto_clasificacion.IdClasificacion ON dbo.producto_familia.IdFamilia = dbo.cliente_tiempos.IdFamilia RIGHT OUTER JOIN
                         dbo.producto_bodega INNER JOIN
                         dbo.producto ON dbo.producto_bodega.IdProducto = dbo.producto.IdProducto ON dbo.producto_familia.IdFamilia = dbo.producto.IdFamilia AND 
                         dbo.producto_clasificacion.IdClasificacion = dbo.producto.IdClasificacion RIGHT OUTER JOIN
                         dbo.unidad_medida INNER JOIN
                         dbo.propietarios INNER JOIN
                         dbo.stock INNER JOIN
                         dbo.propietario_bodega ON dbo.stock.IdPropietarioBodega = dbo.propietario_bodega.IdPropietarioBodega ON dbo.propietarios.IdPropietario = dbo.propietario_bodega.IdPropietario ON 
                         dbo.unidad_medida.IdUnidadMedida = dbo.stock.IdUnidadMedida INNER JOIN
                         dbo.bodega_tramo INNER JOIN
                         dbo.bodega_ubicacion ON dbo.bodega_tramo.IdTramo = dbo.bodega_ubicacion.IdTramo AND dbo.bodega_tramo.IdArea = dbo.bodega_ubicacion.IdArea AND dbo.bodega_tramo.IdSector = dbo.bodega_ubicacion.IdSector AND 
                         dbo.bodega_tramo.IdBodega = dbo.bodega_ubicacion.IdBodega ON dbo.stock.IdBodega = dbo.bodega_ubicacion.IdBodega AND dbo.stock.IdUbicacion = dbo.bodega_ubicacion.IdUbicacion ON 
                         dbo.producto_bodega.IdProductoBodega = dbo.stock.IdProductoBodega LEFT OUTER JOIN
                         dbo.trans_oc_pol RIGHT OUTER JOIN
                         dbo.trans_re_oc INNER JOIN
                         dbo.trans_oc_enc ON dbo.trans_re_oc.IdOrdenCompraEnc = dbo.trans_oc_enc.IdOrdenCompraEnc LEFT OUTER JOIN
                         dbo.motivo_devolucion ON dbo.trans_oc_enc.IdMotivoDevolucion = dbo.motivo_devolucion.IdMotivoDevolucion ON dbo.trans_oc_pol.IdOrdenCompraEnc = dbo.trans_oc_enc.IdOrdenCompraEnc ON 
                         dbo.stock.IdRecepcionEnc = dbo.trans_re_oc.IdRecepcionEnc LEFT OUTER JOIN
                         dbo.indice_rotacion ON dbo.producto.IdIndiceRotacion = dbo.indice_rotacion.IdIndiceRotacion LEFT OUTER JOIN
                         dbo.stock_res ON dbo.stock.IdStock = dbo.stock_res.IdStock LEFT OUTER JOIN
                         dbo.producto_estado ON dbo.stock.IdProductoEstado = dbo.producto_estado.IdEstado LEFT OUTER JOIN
                         dbo.producto_presentacion ON dbo.stock.IdPresentacion = dbo.producto_presentacion.IdPresentacion
WHERE        (dbo.stock.IdUbicacion NOT IN
                             (SELECT        IdUbicacion
                               FROM            dbo.bodega_ubicacion AS bodega_ubicacion_1
                               WHERE        (ubicacion_despacho = 1)))
GROUP BY dbo.propietarios.nombre_comercial, dbo.propietarios.IdPropietario, dbo.stock.IdStock, dbo.bodega_ubicacion.IdUbicacion, dbo.stock.IdUbicacion_anterior, dbo.propietario_bodega.IdPropietarioBodega, 
                         dbo.producto_bodega.IdProductoBodega, dbo.unidad_medida.IdUnidadMedida, dbo.unidad_medida.Nombre, dbo.producto_presentacion.nombre, dbo.producto.IdProducto, dbo.producto.codigo, dbo.producto.nombre, 
                         dbo.stock.lote, dbo.stock.fecha_ingreso, dbo.stock.serial, dbo.stock.añada, dbo.producto_bodega.IdBodega, dbo.stock.fecha_vence, dbo.stock.IdProductoEstado, dbo.producto_estado.nombre, dbo.producto_estado.utilizable, 
                         dbo.producto_estado.dañado, dbo.stock.IdUbicacion, dbo.stock.IdPresentacion, dbo.stock.IdRecepcionEnc, dbo.stock.lic_plate, dbo.stock.peso, dbo.producto.IdIndiceRotacion, dbo.producto_presentacion.alto, 
                         dbo.producto_presentacion.largo, dbo.producto_presentacion.ancho, dbo.producto_presentacion.factor, dbo.bodega_ubicacion.IdTramo, dbo.bodega_ubicacion.ancho, dbo.bodega_ubicacion.largo, dbo.bodega_ubicacion.alto, 
                         dbo.indice_rotacion.Descripcion, dbo.producto.existencia_min, dbo.producto.existencia_max, dbo.producto.codigo_barra, dbo.producto.costo, dbo.producto_presentacion.MinimoExistencia, 
                         dbo.producto_presentacion.MaximoExistencia, dbo.stock.cantidad, dbo.stock.cantidad / dbo.producto_presentacion.factor, dbo.stock.atributo_variante_1, dbo.bodega_ubicacion.nivel, dbo.bodega_ubicacion.indice_x, 
                         dbo.bodega_ubicacion.descripcion, dbo.bodega_tramo.descripcion, dbo.bodega_ubicacion.orientacion_pos, dbo.motivo_devolucion.Nombre, dbo.trans_oc_pol.NoPoliza, dbo.producto_clasificacion.IdClasificacion, 
                         dbo.producto_familia.IdFamilia, dbo.cliente_tiempos.Dias_Local, dbo.cliente_tiempos.Dias_Exterior, dbo.cliente_tiempos.IdCliente, dbo.stock.IdBodega, dbo.stock_res.IdPicking, dbo.stock_res.IdPedido
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[50] 4[12] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "producto_familia"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cliente_tiempos"
            Begin Extent = 
               Top = 6
               Left = 262
               Bottom = 136
               Right = 454
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "producto_clasificacion"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "producto_bodega"
            Begin Extent = 
               Top = 138
               Left = 262
               Bottom = 268
               Right = 466
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "producto"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "unidad_medida"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 231
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "propietarios"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 664
               Right = 278' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_Stock_Por_Producto_Ubicacion_CI'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "stock"
            Begin Extent = 
               Top = 666
               Left = 38
               Bottom = 796
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "propietario_bodega"
            Begin Extent = 
               Top = 798
               Left = 38
               Bottom = 928
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bodega_tramo"
            Begin Extent = 
               Top = 930
               Left = 38
               Bottom = 1060
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bodega_ubicacion"
            Begin Extent = 
               Top = 1062
               Left = 38
               Bottom = 1192
               Right = 252
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "trans_oc_pol"
            Begin Extent = 
               Top = 1194
               Left = 38
               Bottom = 1324
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "trans_re_oc"
            Begin Extent = 
               Top = 1326
               Left = 38
               Bottom = 1456
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "trans_oc_enc"
            Begin Extent = 
               Top = 1458
               Left = 38
               Bottom = 1588
               Right = 285
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "motivo_devolucion"
            Begin Extent = 
               Top = 1590
               Left = 38
               Bottom = 1720
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "indice_rotacion"
            Begin Extent = 
               Top = 402
               Left = 269
               Bottom = 532
               Right = 463
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "stock_res"
            Begin Extent = 
               Top = 1722
               Left = 38
               Bottom = 1852
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "producto_estado"
            Begin Extent = 
               Top = 1854
               Left = 38
               Bottom = 1984
               Right = 247
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "producto_presentacion"
            Begin Extent = 
               Top = 1986
               Left = 38
               Bottom = 2116
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_Stock_Por_Producto_Ubicacion_CI'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane3', @value=N'er = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_Stock_Por_Producto_Ubicacion_CI'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=3 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_Stock_Por_Producto_Ubicacion_CI'
GO

