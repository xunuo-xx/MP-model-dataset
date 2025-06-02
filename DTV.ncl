load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin

  b = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")   ; read in land sea mask basemap file
;-------------------
  f_c = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip_r1i1p1f1_gr.nc","r")
   u_c = f_c->orog

  f_cn = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr.nc","r")
   u = f_cn->orog

   v= u_c
   v=u_c - u

  lat_FAMIL = doubletofloat(f_c->lat)
  lon_FAMIL = doubletofloat(f_c->lon)
 nlat_FAMIL = dimsizes(lat_FAMIL)
 nlon_FAMIL = dimsizes(lon_FAMIL)
  lat_FAMIL@units="degrees_north"
  lon_FAMIL@units="degrees_east"

  fh = addfile("/data4/2023xunuo/MongoliaData/huatu/DTV/amip/amip_DTV_79-21","r")
  fh_n=addfile("/data4/2023xunuo/MongoliaData/huatu/DTV/amip_NMO/amip_NMO_DTV_79-21.nc","r")
  fh_ns=addfile("/data4/2023xunuo/MongoliaData/huatu/DTV/amip_NS_MO/amip_NS_MO_DTV_79-21.nc","r")
  
  dtv = fh->DTV(:,:,:,:)
  dtv = fh->DTV(:,:,:,:)*86400.
  dtv_m = dim_avg_n_Wrap(dtv,0)
  dtv_n = fh_n->DTV(:,:,:,:)
  dtv_n = fh_n->DTV(:,:,:,:)*86400.
  dtv_n_m = dim_avg_n_Wrap(dtv_n,0)
  dtv_ns = fh_ns->DTV(:,:,:,:)
  dtv_ns= fh_ns->DTV(:,:,:,:)*86400.
  dtv_ns_m = dim_avg_n_Wrap(dtv_ns,0)
  ;-----------------------------------------------------------------------------
  f_a = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip_r1i1p1f1_gr.nc","r")
  o_a = f_a->orog
  f_nmo=addfile("/data4/2023xunuo/MongoliaData/data/amip-NMO/fx/orog_fx_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr.nc","r")
  o_nmo= f_nmo->orog
  f_ns=addfile("/data4/2023xunuo/MongoliaData/data/amip-NS_MO/fx/orog_fx_FGOALS-f3-L_amip-NS-MO_r1i1p1f1_gr.nc","r")
  o_ns= f_ns->orog
  ;-----------------------------------------------------------------------------
   wks = gsn_open_wks("pdf","dtv")  ; open a ps file
  plot=new((/3/),graphic)
  plot_mp=new((/3/),graphic)
  plot_orog=new((/3/),graphic) 
   gsn_define_colormap(wks,"BlueDarkRed18")
;-----------------------------------------------------------------------------
   res                  = True       ; use plot options
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineLabelsOn       = False              ; turn off contour line labels
  res@cnFillMode           ="AreaFill"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
  res@cnMinLevelValF        =  -8.0          ; set min contour level
  res@cnMaxLevelValF        =  8.0          ; set max contour level
  res@cnLevelSpacingF       =  1.  ; set contour interval
  res@gsnFrame         = False
  res@gsnDraw                = False
  res@gsnSpreadColors      = True               ; use full color map
  res@gsnLeftString = ""
  res@gsnCenterString = ""
  res@gsnRightString = " "
  res@gsnStringFontHeightF = 0.025
  res@gsnMaximize      = True       ; fill up the page
  res@gsnAddCyclic   = True;False
  res@gsnPaperOrientation = "portrait"
  res@gsnContourZeroLineThicknessF = 2.                               ;set thickness of zero
  res@lbLabelBarOn = False                                                       ; turn off the label bar
  res@lbOrientation          = "horizontal";"vertical"
  res@lbLabelFontHeightF  = 0.025                                   ; make labels smaller
  res@lbLabelStride = 2
  res@mpFillOn   = True                                                                  ; turn off gray continents
  res@mpGeophysicalLineThicknessF = 2
  res@mpGeophysicalLineColor      = "black" 
  ;res@mpCenterLonF = 180.
  res@mpMaxLatF  = 63
  res@mpMinLatF  = 35
  res@mpMaxLonF  = 140
  res@mpMinLonF  = 80
  res@lbTopMarginF = 0.4
  res@tmXBTickSpacingF = 10
  res@tmYLTickSpacingF = 10
  res@tmXBLabelFontHeightF = 0.025
  res@tmXBLabelFontThicknessF = 2.0
  res@tmYLLabelFontHeightF = 0.025
  res@tmYLLabelFontThicknessF = 2.0
;-----------------------------------------------------------------------------
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
  res3                  = True       ; use plot options
  res3@cnFillOn         = False;True       ; Fill contours
  res3@cnLinesOn        = True      ; turn off contour lines
; for tp masking  
  res3@gsnFrame         = False
  res3@gsnDraw  = False 
  res3@cnLineLabelsOn   = False      ; turn off contour line labels
  res3@cnLineThicknessF = 6
  res3@cnLineColor      = "green"
  res3@cnInfoLabelOn = False
  res3@cnLevelSelectionMode="ExplicitLevels"
  res3@cnLevels = (/118/)
  res3@gsnLeftString      = " "
  res3@gsnRightString      = " "
;-----------------------------------------------------------------------------
  res4                  = True       ; use plot options
  res4@cnFillOn         = False    ; Fill contours
  res4@cnLinesOn        = True      ; turn off contour lines  
  res4@gsnFrame         = False
  res4@gsnDraw          = False 
  res4@cnLineLabelsOn   = False      ; turn off contour line labels
  res4@cnLineThicknessF = 3           ;粗细
  res4@cnLineColor      = "black"
  res4@cnInfoLabelOn    = False
  res4@cnLevelSelectionMode="ExplicitLevels"

  res4@cnLevels = (/500,1000,1500/)
  res4@gsnLeftString      = " "
  res4@gsnRightString      = " "
  res4@cnLineLabelsOn      =True
  res4@cnLabelDrawOrder    ="PostDraw"
  res4@cnLineLabelAngleF   =0.0
  res4@cnLineLabelFontHeightF =0.01
  res4@cnLineLabelFontThicknessF =0.8
  res4@cnLineLabelDensityF =1
  res4@cnLineLabelInterval =1
  res4@cnInfoLabelOn       =False
  res4@tmXBTickSpacingF = 10
  res4@tmYLTickSpacingF = 10
  res4@tmXBLabelFontHeightF = 0.025
  res4@tmXBLabelFontThicknessF = 2.0
  res4@tmYLLabelFontHeightF = 0.025
  res4@tmYLLabelFontThicknessF = 2.0
;-----------------------------------------------------------------------------

   res@gsnLeftString =  "(a) amip"
  res@gsnCenterString = ""
   plot(0) = gsn_csm_contour_map_ce(wks,dtv_m(31,:,:),res) ; create a default plot


   res@gsnLeftString =  "(b) amip_NMO"
  res@gsnCenterString = ""
   plot(1)= gsn_csm_contour_map_ce(wks,dtv_n_m(31,:,:),res) ; create a default plot

   res@gsnLeftString =  "(c) amip_NS_MO"
  res@gsnCenterString = ""
   plot(2)= gsn_csm_contour_map_ce(wks,dtv_ns_m(31,:,:),res) ; create a default plot

   plot_mp(0) = gsn_csm_contour(wks,v({30:70},{80:140}),res3)
   plot_mp(1) = gsn_csm_contour(wks,v({30:70},{80:140}),res3)
   plot_mp(2) = gsn_csm_contour(wks,v({30:70},{80:140}),res3)
   
   plot_orog(0) = gsn_csm_contour(wks,o_a, res2)
   plot_orog(1) = gsn_csm_contour(wks,o_nmo, res2)
   plot_orog(2) = gsn_csm_contour(wks,o_ns, res2)

   overlay(plot(0), plot_orog(0))
   overlay(plot(1), plot_orog(1))
   overlay(plot(2), plot_orog(2))

   overlay(plot(0),plot_mp(0))
   overlay(plot(1),plot_mp(1))
   overlay(plot(2),plot_mp(2))
   

   resP                       =True
  resP@gsnPanelLabelBar    = True                ; add common colorbar
  resP@lbLabelFontHeightF  = 0.015               ; make labels smaller
  resP@gsnPanelLabelBar    =True
  resP@lbLabelStride = 2 
  
    gsn_panel(wks,plot,(/3,1/),resP)

  ;draw(plot)
  ;frame(wks)

 end
