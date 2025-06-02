; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
;----------------------------------------------------------------------
begin
  f_c = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip_r1i1p1f1_gr.nc","r")
   u_c = f_c->orog
  f = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr.nc","r")
   u = f->orog    
   v =  u_c
   v = u_c - u 

  lat_FAMIL = doubletofloat(f_c->lat)
  lon_FAMIL = doubletofloat(f_c->lon)
 nlat_FAMIL = dimsizes(lat_FAMIL)
 nlon_FAMIL = dimsizes(lon_FAMIL)
  lat_FAMIL@units="degrees_north"
  lon_FAMIL@units="degrees_east"
;------------------------------------------------
  wks  = gsn_open_wks("pdf","orog")    ; send graphics to PNG file
    plot=new((/3/),graphic)
    plot_mp=new((/3/),graphic)
;---Set some resources for color contour lines

   res                         = True
   res@cnFillOn              = True               ; turn on color for contours
   res@cnLinesOn              = False              ; turn off contour lines
   res@cnLineLabelsOn         = False              ; turn off contour line labels
   res@cnFillPalette          ="topo_15lev"      ;"BlAqGrWh2YeOrReVi22"         
   res@cnLevelSelectionMode   = "ManualLevels"        ; set manual contour levels
   res@cnMinLevelValF        =  200.0                ; set min contour level
   res@cnMaxLevelValF        =  3000.0              ; set max contour level
   res@cnLevelSpacingF       =  200.                 ; set contour interval
   res@cnFillMode            ="AreaFill"
  res@gsnFrame                    = False
  res@gsnDraw                     = False
  res@gsnSpreadColors            = False              ; use full color map
  res@gsnLeftString = ""
  res@gsnCenterString =""
  res@gsnRightString = ""
  res@gsnStringFontHeightF = 0.025
  res@gsnMaximize       = True                                        ; fill up the page
  res@gsnAddCyclic      = True;
  res@gsnPaperOrientation = "portrait"
  res@lbLabelBarOn            = True                                 ; turn off the label bar
  res@lbOrientation          = "Vertical"
  res@lbLabelFontHeightF  = 0.025                               ; make labels smaller
  res@lbLabelStride = 2
  res@mpFillOn                = True                                     ; turn off gray continents
  res@mpGeophysicalLineThicknessF = 2
  res@mpGeophysicalLineColor      = "black"
  res@mpFillColor="white"
  res@mpOutlineOn=True
  res@mpInlandWaterFillColor=0
  res@mpLandFillColor=0
  res@mpMonoFillColor=True
  res@mpOceanFillColor=0
  res@mpGeophysicalLineDashPattern=0
  res@mpGeophysicalLineThicknessF=2
  res@mpCenterLonF = 180.
  res@mpMaxLatF  = 63
  res@mpMinLatF  = 35
  res@mpMaxLonF  = 140
  res@mpMinLonF  = 80  
  res@tmXBTickSpacingF = 10
  res@tmYLTickSpacingF = 10
  res@tmXBLabelFontHeightF = 0.025
  res@tmXBLabelFontThicknessF = 2.0
  res@tmYLLabelFontHeightF = 0.025
  res@tmYLLabelFontThicknessF = 2.0
;-----------------------------------------------------------------------------
  res3                  = True       ; use plot options
  res3@cnFillOn         = False    ; Fill contours
  res3@cnLinesOn        = True      ; turn off contour lines  
  res3@gsnFrame         = False
  res3@gsnDraw  = False 
  res3@cnLineLabelsOn   = False      ; turn off contour line labels
  res3@cnLineThicknessF = 6
  res3@cnLineColor      = "red"
  res3@cnInfoLabelOn      = False
  res3@cnLevelSelectionMode="ExplicitLevels"
  res3@cnLevels = (/118.0/)
  res3@gsnLeftString      = " "
  res3@gsnRightString      = " "
;-----------------------------------------------------

  res@gsnLeftString =  "(a) amip"
  res@gsnCenterString = ""
     plot(0) = gsn_csm_contour_map(wks,u_c,res)
   
  res@gsnLeftString =  "(b) amip_NMO"
  res@gsnCenterString = ""
      plot(1) = gsn_csm_contour_map(wks,u,res)
      
  res@gsnLeftString =  "(c) amip-amip_NMO"
  res@gsnCenterString = ""
  res@cnFillPalette          = "amwg"
  res@cnLevelSelectionMode = "ExplicitLevels"
  res@cnLevels     = (/200,400,600,800,1000,1200,1400,1600,1800,2000/)
  res@cnFillColors = (/-1,2,3,4,6,8,10,12,13,14,15/)
  res@lbLabelBarOn            = True                                 ; turn off the label bar
  res@lbOrientation          = "Vertical"
      plot(2) = gsn_csm_contour_map(wks,v,res)
      
  plot_mp(0) = gsn_csm_contour(wks,v,res3)
  plot_mp(1) = gsn_csm_contour(wks,v,res3)
  plot_mp(2) = gsn_csm_contour(wks,v,res3)

  overlay(plot(0),plot_mp(0))
  overlay(plot(1),plot_mp(1))
  overlay(plot(2),plot_mp(2))

 resP                       =True
  resP@gsnPanelLabelBar    = False                ; add common colorbar
  resP@lbLabelFontHeightF  = 0.015               ; make labels smaller
  resP@gsnPanelLabelBar    =False
    gsn_panel(wks,plot,(/3,1/),resP)

end


