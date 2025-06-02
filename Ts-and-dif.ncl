begin

  f2_c=addfile("/data4/2023xunuo/MongoliaData/huatu/tas_Amon_FGOALS-f3-L_amip_r1i1p1f1_gr_197901-202111.nc","r")
     tas_k=f2_c->tas
     LAT=f2_c->lat
     LON=f2_c->lon

  f2=addfile("/data4/2023xunuo/CRU/t2m_mean_Amon/crut_ts_197901-202111_tmp.nc","r")
     t2m_cru=f2->tmp
     lat_cru=f2->lat
     lon_cru=f2->lon
    
    qsort(LAT)
    qsort(LON)
    qsort(lon_cru)
    qsort(lat_cru)

    t2m=linint2_Wrap(lon_cru, lat_cru, t2m_cru, True, LON, LAT, 0)


     a= addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")   ; read in land sea mask basemap file
     oro = a->LSMASK
   
     tas1=landsea_mask(oro, tas_k&lat, tas_k&lon)
     tas_k=mask(tas_k,tas1.eq.0,False)
    
  f3=addfile("/data4/2023xunuo/MongoliaData/data/amip-NMO/Amon/tas_Amon_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr_197901-202111.nc","r")
    tas_nmo_k=f3->tas

  f4=addfile("/data4/2023xunuo/MongoliaData/data/amip-NS_MO/Amon/tas_Amon_FGOALS-f3-L_amip-NS-MO_r1i1p1f1_gr_197901-202111.nc","r")
    tas_ns_k=f4->tas
  
    tas1=landsea_mask(oro, tas_k&lat, tas_k&lon)
    tas_nmo_k=mask(tas_nmo_k,tas1.eq.0,False)
    tas_ns_k=mask(tas_ns_k,tas1.eq.0,False)

    tas=tas_k
    tas=tas_k - 273
    tas_nmo=tas_nmo_k
    tas_nmo=tas_nmo_k - 273
    tas_ns=tas_ns_k
    tas_ns=tas_ns_k - 273

   tas_m =dim_avg_n_Wrap(tas,0)
   t2m_m =dim_avg_n_Wrap(t2m,0)
   tas_nmo_m =dim_avg_n_Wrap(tas_nmo,0)
   tas_ns_m =dim_avg_n_Wrap(tas_ns,0)
   
   t2m_dif=tas_m - t2m_m
   LAT@units="degrees_north"
   LON@units="degrees_east"
   t2m_dif!0 = "lat"
   t2m_dif&lat = LAT
   t2m_dif!1 = "lon"
   t2m_dif&lon = LON
   
   lat_FAMIL = doubletofloat(f2_c->lat)
   lon_FAMIL = doubletofloat(f2_c->lon)
  nlat_FAMIL = dimsizes(lat_FAMIL)
  nlon_FAMIL = dimsizes(lon_FAMIL)
   lat_FAMIL@units="degrees_north"
   lon_FAMIL@units="degrees_east"

   ;-----------------------------------------------------------------------------
   f_a = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip_r1i1p1f1_gr.nc","r")
   o_a = f_a->orog
   ;-----------------------------------------------------------------------------
     wks = gsn_open_wks("pdf","Ts-and-dif")
     plot = new((/3/),graphic)
     plot_orog=new((/3/),graphic) 
;-----------------------------------------------------------------------------
   res                         = True
   res@cnFillOn              = True               ; turn on color for contours
   res@cnLinesOn              = False              ; turn off contour lines
   res@cnLineLabelsOn         = False              ; turn off contour line labels
   res@cnFillPalette          = "GMT_polar";"hotcold_18lev" ;"BlueDarkRed18"     ; set color map
   res@cnFillMode             ="AreaFill"
   res@cnLevelSelectionMode   = "ManualLevels"        ; set manual contour levels
   res@cnMinLevelValF        =  -18.0                ; set min contour level
   res@cnMaxLevelValF        =  18.0              ; set max contour level
   res@cnLevelSpacingF       =  2.0                           ; set contour interval
  res@gsnFrame                    = False
  res@gsnDraw                     = False
  res@gsnSpreadColors                  = False              ; use full color map
  res@gsnLeftString = ""
  res@gsnCenterString =""
  res@gsnRightString = ""
  res@gsnStringFontHeightF = 0.025
  res@gsnMaximize       = True                                        ; fill up the page
  res@gsnAddCyclic      = True
  res@gsnPaperOrientation = "portrait"
  res@gsnContourZeroLineThicknessF = 2.                           ;set thickness of zero
  res@lbLabelBarOn            = True                                 ; turn off the label bar
  res@lbOrientation          = "Vertical"
  res@lbLabelFontHeightF  = 0.015               ; make labels smaller
  res@pmLabelBarWidthF       =0.08                               ;色标宽度
  res@pmLabelBarHeightF      =0.4                                 ;色标高度
  res@lbLabelStride = 1 
  res@mpFillOn                = True                                     ; turn off gray continents
  res@mpGeophysicalLineThicknessF = 2
  res@mpGeophysicalLineColor      = "black"
  ; res@mpCenterLonF = 180.
  res@mpMaxLatF  = 65
  res@mpMinLatF  = 30
  res@mpMaxLonF  = 140
  res@mpMinLonF  = 80
  res@lbTopMarginF = 0.4
  res@tmXBTickSpacingF = 10
  res@tmYLTickSpacingF = 10
  res@tmXBLabelFontHeightF = 0.025
  res@tmXBLabelFontThicknessF = 2.0
  res@tmYLLabelFontHeightF = 0.025
  res@tmYLLabelFontThicknessF = 2.0
;-----------------------------------------------------
res2                  = True       ; use plot options
res2@cnFillOn         = False    ; Fill contours
res2@cnLinesOn        = True      ; turn off contour lines  
res2@gsnFrame         = False
res2@gsnDraw          = False 
res2@cnLineLabelsOn   = False      ; turn off contour line labels
res2@cnLineThicknessF = 3           ;粗细
res2@cnLineColor      = "black"
res2@cnInfoLabelOn    = False
res2@cnLevelSelectionMode="ExplicitLevels"
res2@cnLevels = (/1000,1500/)
res2@gsnLeftString      = " "
res2@gsnRightString      = " "
res2@cnLineLabelsOn      =True
res2@cnLabelDrawOrder    ="PostDraw"
res2@cnLineLabelAngleF   =0.0
res2@cnLineLabelFontHeightF =0.01
res2@cnLineLabelFontThicknessF =0.8
res2@cnLineLabelDensityF =1
res2@cnLineLabelInterval =1
res2@cnInfoLabelOn       =False
res2@tmXBTickSpacingF = 10
res2@tmYLTickSpacingF = 10
res2@tmXBLabelFontHeightF = 0.025
res2@tmXBLabelFontThicknessF = 2.0
res2@tmYLLabelFontHeightF = 0.025
res2@tmYLLabelFontThicknessF = 2.0
 ;-----------------------------------------------------     
  res@gsnLeftString =  "(a) T2m_CRU"
  res@gsnCenterString = ""
      plot(0)=gsn_csm_contour_map(wks,t2m_m,res)
      
  res@gsnLeftString =  "(b) T2m_amip"
  res@gsnCenterString = ""
      plot(1)=gsn_csm_contour_map(wks,tas_m,res)

  res@gsnLeftString =  "(c) T2m_amip-CRU"
  res@gsnCenterString = ""
      res@cnFillPalette          ="precip_diff_12lev"   ;"amwg""BlueDarkRed18"  "hotcold_18lev" ; ; set color map
      res@cnFillMode             ="AreaFill"
      res@cnLevelSelectionMode   = "ExplicitLevels"        ; set manual contour levels
      res@cnLevels            =(/-8,-4,-2,-1,-0.5,0,0.5,1,2,4,8/)
      res@cnFillColors        =(/0,1,2,3,4,5,7,8,9,10,11,12,13,14/)
    plot(2)=gsn_csm_contour_map(wks,t2m_dif,res)


   plot_orog(0) = gsn_csm_contour(wks,o_a, res2)
   plot_orog(1) = gsn_csm_contour(wks,o_a, res2)
   plot_orog(2) = gsn_csm_contour(wks,o_a, res2)

   overlay(plot(0), plot_orog(0))
   overlay(plot(1), plot_orog(1))
   overlay(plot(2), plot_orog(2))


 resP                       =True
  resP@gsnPanelLabelBar    = False                ; add common colorbar
  resP@lbLabelFontHeightF  = 0.015               ; make labels smaller

 resP@lbOrientation          = "horizontal"     ;"vertical"
    gsn_panel(wks,plot,(/3,1/),resP)

end