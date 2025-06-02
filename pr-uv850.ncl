load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin

fu    = addfile("/data4/2023xunuo/MongoliaData/huatu/ua/ua_amip_7901-2012.nc","r")
 funmo = addfile("/data4/2023xunuo/MongoliaData/huatu/ua/ua_amip-NMO_7901-2012.nc","r")
 funs  = addfile("/data4/2023xunuo/MongoliaData/huatu/ua/ua_amip-NS-MO_7901-2012.nc", "r")
 
 fv    = addfile("/data4/2023xunuo/MongoliaData/huatu/va/va_amip_7901-2012.nc","r")
 fvnmo = addfile("/data4/2023xunuo/MongoliaData/huatu/va/va_amip-NMO_7901-2012.nc","r")
 fvns  = addfile("/data4/2023xunuo/MongoliaData/huatu/va/va_amip-NS-MO_7901-2012.nc", "r")
  
 hisu=fu->ua
 histu=hisu(:,::-1,:,:)
 hisunmo=funmo->ua
 histunmo=hisunmo(:,::-1,:,:)
 hisuns=funs->ua
 histuns=hisuns(:,::-1,:,:)
 hisv=fv->va
 histv=hisv(:,::-1,:,:)
 hisvnmo=fvnmo->va
 histvnmo=hisvnmo(:,::-1,:,:)
 hisvns=fvns->va
 histvns=hisvns(:,::-1,:,:)
 
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

 newu =vinth2p(histu, hyam, hybm, levv, PS, 1, 1000., 1, False)
 newunmo =vinth2p(histunmo, hyam, hybm, levv, PS_nmo, 1, 1000., 1, False)
 newuns =vinth2p(histuns, hyam, hybm, levv, PS_ns, 1, 1000., 1, False)
 newv =vinth2p(histv, hyam, hybm, levv, PS, 1, 1000., 1, False)
 newvnmo =vinth2p(histvnmo, hyam, hybm, levv, PS_nmo, 1, 1000., 1, False)
 newvns =vinth2p(histvns, hyam, hybm, levv, PS_ns, 1, 1000., 1, False)

 newu_m=dim_avg_n_Wrap(newu, 0)
 newu_JJA=month_to_season(newu, "JJA")
 newu_DJF=month_to_season(newu, "DJF")
 newu_JJA_m=dim_avg_n_Wrap(newu_JJA, 0)
 newu_DJF_m=dim_avg_n_Wrap(newu_DJF, 0)

 newunmo_m=dim_avg_n_Wrap(newunmo, 0) 
 newunmo_JJA=month_to_season(newunmo, "JJA")
 newunmo_DJF=month_to_season(newunmo, "DJF")
 newunmo_JJA_m=dim_avg_n_Wrap(newunmo_JJA, 0)
 newunmo_DJF_m=dim_avg_n_Wrap(newunmo_DJF, 0)

 newuns_m=dim_avg_n_Wrap(newuns, 0)
 newuns_JJA=month_to_season(newuns, "JJA")
 newuns_DJF=month_to_season(newuns, "DJF")
 newuns_JJA_m=dim_avg_n_Wrap(newuns_JJA, 0)
 newuns_DJF_m=dim_avg_n_Wrap(newuns_DJF, 0)

 newv_m=dim_avg_n_Wrap(newv, 0)
 newv_JJA=month_to_season(newv, "JJA")
 newv_DJF=month_to_season(newv, "DJF")
 newv_JJA_m=dim_avg_n_Wrap(newv_JJA, 0)
 newv_DJF_m=dim_avg_n_Wrap(newv_DJF, 0)

 newvnmo_m=dim_avg_n_Wrap(newvnmo, 0)
 newvnmo_JJA=month_to_season(newvnmo, "JJA")
 newvnmo_DJF=month_to_season(newvnmo, "DJF")
 newvnmo_JJA_m=dim_avg_n_Wrap(newvnmo_JJA, 0)
 newvnmo_DJF_m=dim_avg_n_Wrap(newvnmo_DJF, 0)

 newvns_m=dim_avg_n_Wrap(newvns, 0)
 newvns_JJA=month_to_season(newvns, "JJA")
 newvns_DJF=month_to_season(newvns, "DJF")
 newvns_JJA_m=dim_avg_n_Wrap(newvns_JJA, 0)
 newvns_DJF_m=dim_avg_n_Wrap(newvns_DJF, 0)
  
 fu_ERA5=addfile("/data4/2023xunuo/ERA5/monthly/uv/u_component_of_wind/ERA5_u_ymonmean_1979-2020_360*180.nc", "r")
 u_era5=fu_ERA5->u
 fv_ERA5=addfile("/data4/2023xunuo/ERA5/monthly/uv/v_component_of_wind/ERA5_v_ymonmean_1979-2020_360*180.nc", "r")
 v_era5=fv_ERA5->v

 u_e_m=dim_avg_n_Wrap(u_era5, 0)
 u_e_JJA=month_to_season(u_era5, "JJA")
 u_e_JJA_m=dim_avg_n_Wrap(u_e_JJA, 0)
 u_e_DJF=month_to_season(u_era5, "DJF")
 u_e_DJF_m=dim_avg_n_Wrap(u_e_DJF, 0)
 v_e_m=dim_avg_n_Wrap(v_era5, 0)
 v_e_JJA=month_to_season(v_era5, "JJA")
 v_e_JJA_m=dim_avg_n_Wrap(v_e_JJA, 0)
 v_e_DJF=month_to_season(v_era5, "DJF")
 v_e_DJF_m=dim_avg_n_Wrap(v_e_DJF, 0)
;-------------------
  pr_GPCP = addfile("/data4/2023xunuo/GPCP/precip.mon.mean_197901_202111.nc","r")
   ;print(pr_GPCP)
  pr_g_l = pr_GPCP->precip
   lat_G = pr_GPCP->lat
   lon_G = pr_GPCP->lon

  pr_amip = addfile("/data4/2023xunuo/MongoliaData/huatu/pr/pr_Amon_FGOALS-f3-L_amip_r1i1p1f1_gr_197901-202111.nc","r")
   pr_c= pr_amip->pr
   LAT=pr_amip->lat
   LON=pr_amip->lon
  pr_NMO = addfile("/data4/2023xunuo/MongoliaData/huatu/pr/pr_Amon_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr_197901-202111.nc","r")
   pr_nmo=pr_NMO->pr
  pr_NS_MO = addfile("/data4/2023xunuo/MongoliaData/huatu/pr/pr_Amon_FGOALS-f3-L_amip-NS-MO_r1i1p1f1_gr_197901-202111.nc","r")
   pr_ns=pr_NS_MO->pr

   qsort(LAT)
   qsort(LON)
   qsort(lon_G)
   qsort(lat_G)
   pr_g=linint2_Wrap(lon_G, lat_G, pr_g_l, True, LON, LAT, 0)


   a= addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")   ; read in land sea mask basemap file
    oro = a->LSMASK
    pr1=landsea_mask(oro, pr_g&lat, pr_g&lon)
    pr2=landsea_mask(oro, pr_c&lat, pr_c&lon)
    pr3=landsea_mask(oro, pr_nmo&lat, pr_nmo&lon)
    pr4=landsea_mask(oro, pr_ns&lat, pr_ns&lon)
   
   pr_g=mask(pr_g,pr1.eq.0,False)
   pr_c=mask(pr_c,pr2.eq.0,False)
   pr_nmo=mask(pr_nmo,pr3.eq.0,False)
   pr_ns=mask(pr_ns,pr4.eq.0,False)
   
   pr_a= pr_c
   pr_a= pr_c*86400
   pr_n= pr_nmo
   pr_n= pr_nmo*86400
   pr_ns= pr_ns
   pr_ns= pr_ns*86400

  lat_FAMIL = doubletofloat(pr_amip->lat)
  lon_FAMIL = doubletofloat(pr_amip->lon)
 nlat_FAMIL = dimsizes(lat_FAMIL)
 nlon_FAMIL = dimsizes(lon_FAMIL)
  lat_FAMIL@units="degrees_north"
  lon_FAMIL@units="degrees_east"

  pr_g_m = dim_avg_n_Wrap(pr_g,0)
  pr_a_m = dim_avg_n_Wrap(pr_a,0)
  pr_n_m = dim_avg_n_Wrap(pr_n,0)
  pr_ns_m = dim_avg_n_Wrap(pr_ns,0)

  ;-----------------------------------------------------------------------------

  pr_GPCP_7920 = addfile("/data4/2023xunuo/GPCP/precip_7901-2012.nc", "r")
  pr_g_season_l = pr_GPCP_7920->precip
   lat_season = pr_GPCP_7920->lat
   lon_season = pr_GPCP_7920->lon

  pr_amip_7920 = addfile("/data4/2023xunuo/MongoliaData/huatu/pr/pr_amip_Amon_7901-2012.nc","r")
  pr_c_season = pr_amip_7920->pr
  pr_NMO_7920 = addfile("/data4/2023xunuo/MongoliaData/huatu/pr/pr_amip_NMO_Amon_197901-202012.nc", "r")
   pr_nmo_season = pr_NMO_7920->pr
  pr_NS_7920 = addfile("/data4/2023xunuo/MongoliaData/huatu/pr/pr_amip_NS_MO_Amon_197901-202012.nc","r")
   pr_ns_mo_season = pr_NS_7920->pr

  qsort(lon_season)
  qsort(lat_season)

  pr_g_season = linint2_Wrap(lon_season, lat_season, pr_g_season_l, True, LON, LAT, 0)

  pr3=landsea_mask(oro, pr_g_season&lat, pr_g_season&lon)
  pr4=landsea_mask(oro, pr_c_season&lat, pr_c_season&lon)
  pr5=landsea_mask(oro, pr_nmo_season&lat, pr_nmo_season&lon)
  pr6=landsea_mask(oro, pr_ns_mo_season&lat, pr_ns_mo_season&lon)

 pr_g_season=mask(pr_g_season,pr3.eq.0,False)
 pr_c_season=mask(pr_c_season,pr4.eq.0,False)
 pr_nmo_season=mask(pr_nmo_season,pr5.eq.0,False)
 pr_ns_mo_season=mask(pr_ns_mo_season,pr6.eq.0,False)

  pr_a_season = pr_c_season 
  pr_a_season = pr_c_season*86400
  
  pr_n_season= pr_nmo_season
  pr_n_season= pr_nmo_season*86400
  pr_ns_season= pr_ns_mo_season
  pr_ns_season= pr_ns_mo_season*86400


 pr_g_DJF = month_to_season(pr_g_season, "DJF")
 pr_g_JJA = month_to_season(pr_g_season, "JJA")
 pr_a_DJF = month_to_season(pr_a_season, "DJF")
 pr_a_JJA = month_to_season(pr_a_season, "JJA")
 pr_n_DJF = month_to_season(pr_n_season, "DJF")
 pr_n_JJA = month_to_season(pr_n_season, "JJA")
 pr_ns_DJF = month_to_season(pr_ns_season, "DJF")
 pr_ns_JJA = month_to_season(pr_ns_season, "JJA")

 pr_g_DJF_m = dim_avg_n_Wrap(pr_g_DJF, 0)
 pr_g_JJA_m = dim_avg_n_Wrap(pr_g_JJA, 0)
 pr_a_DJF_m = dim_avg_n_Wrap(pr_a_DJF, 0)
 pr_a_JJA_m = dim_avg_n_Wrap(pr_a_JJA, 0)
 pr_n_DJF_m = dim_avg_n_Wrap(pr_n_DJF, 0)
 pr_n_JJA_m = dim_avg_n_Wrap(pr_n_JJA, 0)
 pr_ns_DJF_m = dim_avg_n_Wrap(pr_ns_DJF, 0)
 pr_ns_JJA_m = dim_avg_n_Wrap(pr_ns_JJA, 0)
;-----------------------------------------------------------------------------
 f_a = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip_r1i1p1f1_gr.nc","r")
 o_a = f_a->orog
 f_nmo=addfile("/data4/2023xunuo/MongoliaData/data/amip-NMO/fx/orog_fx_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr.nc","r")
 o_nmo= f_nmo->orog
 f_ns=addfile("/data4/2023xunuo/MongoliaData/data/amip-NS_MO/fx/orog_fx_FGOALS-f3-L_amip-NS-MO_r1i1p1f1_gr.nc","r")
 o_ns= f_ns->orog
;-----------------------------------------------------------------------------
 wks = gsn_open_wks("pdf","pr-uv850_JJA")  ; open a ps file
  plot=new((/4/),graphic)
  plot_uv=new((/4/),graphic)
  plot_orog=new((/4/),graphic)
  gsn_define_colormap(wks,"amwg")
;-----------------------------------------------------------------------------
   res                  = True       ; use plot options
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineLabelsOn       = False              ; turn off contour line labels
  res@cnFillMode           ="AreaFill"
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
  res@cnMinLevelValF        =  0          ; set min contour level
  res@cnMaxLevelValF        =  5        ; set max contour level
  res@cnLevelSpacingF       =  0.5 ; set contour interval
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
;-----------------------------------------------------------------------------
res2                  = True       ; use plot options
res2@cnFillOn         = False    ; Fill contours
res2@cnLinesOn        = True      ; turn off contour lines  
res2@gsnFrame         = False
res2@gsnDraw          = False 
res2@cnLineLabelsOn   = False      ; turn off contour line labels
res2@cnLineThicknessF = 3          
res2@cnLineColor      = "black"
res2@cnInfoLabelOn    = False
res2@cnLevelSelectionMode="ExplicitLevels"
;res2@cnMaxLevelValF     =2600.0
;res2@cnMinLevelValF     =500.0
;res2@cnLevelSpacingF    =500.0
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
;*************************************************************
vecres                  = True            ; vector only resources
vecres@gsnDraw          = False           ; don't draw
vecres@gsnFrame         = False           ; don't advance frame
vecres@vcGlyphStyle     = "CurlyVector"   ; curly vectors
vecres@vcRefMagnitudeF  = 2              ; define vector ref mag
vecres@vcRefLengthF     = 0.03            ; define length of vec ref
vecres@gsnRightString   = " "             ; turn off right string
vecres@gsnLeftString    = " "             ; turn off left string
vecres@tiXAxisString    = " "             ; turn off axis label 
vecres@vcRefAnnoOrthogonalPosF = -0.12     ; move ref vector into plot
vecres@vcRefAnnoOn      = True            ; draw the reference vector annotation.
vecres@vcRefAnnoString2On = True          ;display a string below or to the right 
vecres@vcRefAnnoString1  = "2 m/s"
vecres@vcRefAnnoString2  = ""
vecres@vcRefAnnoFontHeightF = 0.01
vecres@vcRefAnnoOrientation = "Horizontal"
vecres@vcMinMagnitudeF=5
vecres@vcMinDistanceF=0.02
vecres@vcLineArrowHeadMaxSizeF=0.02
vecres@vcLineArrowHeadMinSizeF=0.0001
vecres@vcLineArrowThicknessF=1.5
vecres@vcLineArrowColor="black"
vecres@vcFillArrowsOn       = True
vecres@vcFillArrowWidthF         = 0.1
vecres@vcFillArrowMinFracWidthF  = 2.0
vecres@vcFillArrowHeadMinFracXF  = 0.0
vecres@vcFillArrowHeadXF         = 0.6
vecres@vcFillArrowHeadInteriorXF = 0.4
vecres@vcFillArrowHeadYF         = 0.5
vecres@vcFillArrowEdgeThicknessF = 0.05
vecres@vcMonoFillArrowEdgeColor = -1

 plot_uv(0) = gsn_csm_vector(wks,u_e_JJA_m(30,:,:),v_e_JJA_m(30,:,:),vecres)
 plot_uv(1) = gsn_csm_vector(wks,newu_JJA_m(2,:,:),newv_JJA_m(2,:,:),vecres)
 plot_uv(2) = gsn_csm_vector(wks,newunmo_JJA_m(2,:,:),newvnmo_JJA_m(2,:,:),vecres)
 plot_uv(3) = gsn_csm_vector(wks,newuns_JJA_m(2,:,:),newvns_JJA_m(2,:,:),vecres)
;-----------------------------------------------------------------------------
   res@gsnLeftString =  "(a) Obs "
   res@gsnCenterString = ""
    plot(0)= gsn_csm_contour_map_ce(wks,pr_g_JJA_m,res)

  res@gsnLeftString =  "(b) amip "
  res@gsnCenterString = ""
    plot(1)= gsn_csm_contour_map_ce(wks,pr_a_JJA_m,res)

   res@gsnLeftString =  "(c) amip_NMO "
   res@gsnCenterString = ""
    plot(2)= gsn_csm_contour_map_ce(wks,pr_n_JJA_m, res)
   
   res@gsnLeftString =  "(d) amip_NS_MO "
   res@gsnCenterString = ""
    plot(3)= gsn_csm_contour_map_ce(wks,pr_ns_JJA_m,res)
  
   plot_orog(0) = gsn_csm_contour(wks,o_a, res2)
   plot_orog(1) = gsn_csm_contour(wks,o_a, res2)
   plot_orog(2) = gsn_csm_contour(wks,o_nmo , res2)
   plot_orog(3) = gsn_csm_contour(wks,o_ns, res2)

   overlay(plot(0), plot_orog(0))
   overlay(plot(1), plot_orog(1))
   overlay(plot(2), plot_orog(2))
   overlay(plot(3), plot_orog(3))

   overlay(plot(0), plot_uv(0))
   overlay(plot(1), plot_uv(1))
   overlay(plot(2), plot_uv(2))
   overlay(plot(3), plot_uv(3))

   resP                       =True
  resP@gsnPanelLabelBar    = True                ; add common colorbar
  resP@lbLabelFontHeightF  = 0.015               ; make labels smaller
  resP@gsnPanelLabelBar    =True
    gsn_panel(wks,plot,(/2,2/),resP)

  ;draw(plot)
  ;frame(wks)

 end
