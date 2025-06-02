begin
  fue=addfile("/data4/2023xunuo/ERA5/monthly/uv/u_component_of_wind/ERA5_u_ymonmean_1979-2020_360*180.nc","r")
  u_e=fue->u(:,:,:,{0:180})
  u_e_m=dim_avg_n_Wrap(u_e, 0)
  u_e_zm=dim_avg_n_Wrap(u_e_m, 2)

  n=addfile("/data12/data_open/FGOALS-f2-L/heb_AMIP70.famil.ver.nc","r")
  hyam = n->hyam   ;from top to bottom in vinth2p funciton
  hybm = n->hybm ; so convert level
  
  p1 = addfile("/data12/CMIP6/FGOALS-f3-L/CMIP/CAS/FGOALS-f3-L/amip/r1i1p1f1/Amon/ta/gr/v20190422/ta_Amon_FGOALS-f3-L_amip_r1i1p1f1_gr_197901-201412.nc","r")
  leee = p1->plev
  levv = leee 
  levv = leee/ 100.0
  p2 = addfile("/data4/2023xunuo/MongoliaData/huatu/ps/ps_amip_7901-2012.nc","r")
  PS = p2->ps
  p2_nmo = addfile("/data4/2023xunuo/MongoliaData/huatu/ps/ps_Amon_amip-NMO_197901-202012.nc","r")
  PS_nmo = p2_nmo->ps
  p2_ns = addfile("/data4/2023xunuo/MongoliaData/huatu/ps/ps_Amon_amip-NS_MO_197901-202012.nc","r")
  PS_ns = p2_ns->ps
  levv@units="hPa"
  
  fu1=addfile("/data4/2023xunuo/MongoliaData/huatu/ua/ua_amip_7901-2012.nc", "r")
    u_amip_his=fu1->ua
    lev_u_a=fu1->lev
    lev_u_amip=lev_u_a(::-1)
    u_amip_h=u_amip_his(:,::-1,:,:)
   u_a =vinth2p(u_amip_h, hyam, hybm, levv, PS, 1, 1000., 1, False)
   u_amip=u_a(:,:,:,{0:180})
 
  u_a_m=dim_avg_n_Wrap(u_amip, 0)    ;lev,lat,lon
  u_a_zm=dim_avg_n_Wrap(u_a_m, 2)    ;lev,lat

  fu2=addfile("/data4/2023xunuo/MongoliaData/huatu/ua/ua_amip-NMO_7901-2012.nc", "r")
  u_nmo_his=fu2->ua
  lev_u_n=fu2->lev
  lev_u_nmo=lev_u_n(::-1)
  u_nmo_h=u_nmo_his(:,::-1,:,:)
  u_n =vinth2p(u_nmo_h, hyam, hybm, levv, PS_nmo, 1, 1000., 1, False)
  u_nmo=u_n(:,:,:,{0:180})
  
 u_n_m=dim_avg_n_Wrap(u_nmo, 0)
 u_n_zm=dim_avg_n_Wrap(u_n_m, 2)
 
  fu3=addfile("/data4/2023xunuo/MongoliaData/huatu/ua/ua_amip-NS-MO_7901-2012.nc", "r")
  u_ns_his=fu3->ua
  lev_u_nsmo=fu2->lev
  lev_u_ns=lev_u_nsmo(::-1)
  u_ns_h=u_ns_his(:,::-1,:,:)
  u_nsmo =vinth2p(u_ns_h, hyam, hybm, levv, PS_ns, 1, 1000., 1, False)
  u_ns=u_nsmo(:,:,:,{0:180})

 u_ns_m=dim_avg_n_Wrap(u_ns, 0)
 u_ns_zm=dim_avg_n_Wrap(u_ns_m, 2)
 ;------------------------------------------------------------------------
  wks =gsn_open_wks("pdf","zonal-u)")
  ;gsn_define_colormap(wks,"rainbow+gray")
  plot=new((/4/),graphic)
;--------------------------------------------------------------------------
 res= True
  res@gsnDraw = False
  res@gsnFrame = False
  res@gsnLeftString  =""
  res@gsnRightString = ""
  res@gsnPresHgtHeightLabelOn = False
  res@cnLevelSelectionMode   = "ManualLevels"        ; set manual contour levels
   res@cnMinLevelValF        =  -14.0                ; set min contour level
   res@cnMaxLevelValF        =  28.0              ; set max contour level
   ;res@cnLevelSpacingF       =  4.                 ; set contour interval
   res@trXMinF=0
   res@trXMaxF=70
  res@tiYAxisString           ="Level (hPa)"
  res@tmYROn      =False
  res@tmXBMode     = "Explicit"
  res@tmXBValues   =(/0,10,20,30,40,50,60,70/)
  res@tmXBLabels   =(/"0","10~S~o~N~N","20~S~o~N~N","30~S~o~N~N","40~S~o~N~N","50~S~o~N~N","60~S~o~N~N","70~S~o~N~N"/)
  res@tmYLMode     = "Explicit"
  res@tmYLValues   =(/1000,400,200,100,50,30,10/)
  res@tmYLLabels   =(/"1000","400","200","100","50","30","10"/)
  res@tmXBLabelFontHeightF = 0.02
  res@tmYLLabelFontHeightF = 0.02
  res@cnFillOn    = True
  res@cnLinesOn   = False
  res@cnLineLabelsOn = False
  res@cnLineLabelFontHeightF=0.02
  res@cnLevelSpacingF =4
  res@cnLineThicknessF =2
  res@gsnContourZeroLineThicknessF = 3. 
  res@cnInfoLabelOn =False
  res@lbLabelBarOn  =False
;--------------------------------------------------------------------------------------------  
  res@gsnLeftString = "(a)ERA5"
  res@gsnCenterString = " "
  plot(0)= gsn_csm_pres_hgt(wks,u_e_zm,res)

  res@gsnLeftString = "(b)amip"
  res@gsnCenterString = " "
  plot(1)= gsn_csm_pres_hgt(wks,u_a_zm,res)

  res@gsnLeftString = "(c)amip_NMO"
  res@gsnCenterString = " "
  plot(2)= gsn_csm_pres_hgt(wks,u_n_zm,res)

  res@gsnLeftString = "(d)amip_NS_MO"
  res@gsnCenterString = " "
  plot(3)= gsn_csm_pres_hgt(wks,u_ns_zm,res)
  
   resP                     = True                ; modify the panel plot
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.015               ; make labels smaller
resP@pmLabelBarWidthF       =0.6                               
resP@pmLabelBarHeightF      =0.06                                 
resP@lbLabelStride = 1                                       
resP@lbOrientation          = "Horizontal"     ;"vertical"

  
  gsn_panel(wks,plot,(/2,2/),resP)
;draw(plot)
;frame(wks)
end
