begin

  b = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")   ; read in land sea mask basemap file

  f_c=addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip_r1i1p1f1_gr.nc","r")
  u_c = f_c->orog
  
  f_cn = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr.nc","r")
  u = f_cn->orog

  v= u_c
  v=u_c - u
  

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
 
 hisu_m=dim_avg_n_Wrap(hisu, 0)
 hisunmo_m=dim_avg_n_Wrap(hisunmo, 0)
 hisuns_m=dim_avg_n_Wrap(hisuns, 0)
 hisv_m=dim_avg_n_Wrap(hisv, 0)
 hisvnmo_m=dim_avg_n_Wrap(hisvnmo, 0)
 hisvns_m=dim_avg_n_Wrap(hisvns, 0)

printVarSummary(hisu_m)

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

 printVarSummary(u_era5)

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

fp    = addfile("/data4/2023xunuo/MongoliaData/huatu/ps/ps_Amon_FGOALS-f3-L_amip_r1i1p1f1_gr_197901-202111.nc","r")
fp_nmo= addfile("/data4/2023xunuo/MongoliaData/huatu/ps/ps_Amon_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr_197901-202111.nc","r")
fp_ns =addfile("/data4/2023xunuo/MongoliaData/huatu/ps/ps_Amon_FGOALS-f3-L_amip-NS-MO_r1i1p1f1_gr_197901-202111.nc","r")
fP_era5=addfile("/data4/2023xunuo/ERA5/monthly/surface_pressure/ERA5-197901-202012_sp_ymonmean_360x180.nc", "r")

print(fp)
print(fp_ns)
print(fp_nmo)
print(fP_era5)

ps_amip=fp->ps
ps_amip_nmo=fp_nmo->ps
ps_amip_ns=fp_ns->ps
ps_era5=fP_era5->sp

a= addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")   ; read in land sea mask basemap file
oro = a->LSMASK

mask1=landsea_mask(oro, ps_amip&lat, ps_amip&lon)
ps_amip=mask(ps_amip,mask1.eq.0,False)
ps_amip_nmo=mask(ps_amip_nmo,mask1.eq.0,False)
ps_amip_ns=mask(ps_amip_ns,mask1.eq.0,False)

mask2=landsea_mask(oro, ps_era5&lat, ps_era5&lon)
ps_era5=mask(ps_era5,mask2.eq.0,False)

ps_a = ps_amip
ps_a = ps_amip / 100
ps_m = dim_avg_n_Wrap(ps_a, 0)
ps_nmo=ps_amip_nmo
ps_nmo=ps_amip_nmo / 100
ps_nmo_m=dim_avg_n_Wrap(ps_nmo, 0)
ps_ns=ps_amip_ns 
ps_ns=ps_amip_ns /100
ps_ns_m=dim_avg_n_Wrap(ps_ns, 0)
ps_e=ps_era5 
ps_e=ps_era5 /100
ps_e_m=dim_avg_n_Wrap(ps_e, 0)

f_a = addfile("/data4/2023xunuo/MongoliaData/huatu/OROG/orog_fx_FGOALS-f3-L_amip_r1i1p1f1_gr.nc","r")
o_a = f_a->orog
f_nmo=addfile("/data4/2023xunuo/MongoliaData/data/amip-NMO/fx/orog_fx_FGOALS-f3-L_amip-NMO_r1i1p1f1_gr.nc","r")
o_nmo= f_nmo->orog
f_ns=addfile("/data4/2023xunuo/MongoliaData/data/amip-NS_MO/fx/orog_fx_FGOALS-f3-L_amip-NS-MO_r1i1p1f1_gr.nc","r")
o_ns= f_ns->orog
;********************************************************
wks = gsn_open_wks("pdf","uv,ps)")  
  plot =new((/4/),graphic)
  plot_mp =new((/4/),graphic)
  plot_uv =new((/4/),graphic)
  plot_orog =new((/4/),graphic)
;-----------------------------------------------------------------------------
  res                  = True       ; use plot options
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineLabelsOn       = False              ; turn off contour line labels
  res@cnFillPalette="BlueDarkRed18"  ;"gui_default"; "cmp_flux" ;"seaice_1";"CBR_wet""precip_11lev";"WGNE15";"CBR_coldhot" ; 
  res@cnLevelSelectionMode = "AutomaticLevels"   ; set manual contour levels
  ; res@cnMinLevelValF       =560.               ; set min contour level
  ; res@cnMaxLevelValF       =1000.               ; set max contour level
  ; res@cnLevelSpacingF      =40. 
  res@gsnFrame         = False
  res@gsnDraw  = False
  res@gsnLeftString = ""
  res@gsnCenterString = ""
  res@gsnRightString = ""
  res@gsnStringFontHeightF = 0.025
  res@gsnMaximize      = True       ; fill up the page
  res@gsnAddCyclic   = False
  res@gsnPaperOrientation = "portrait"
  res@gsnContourZeroLineThicknessF = 2.  ;set thickness of zero
  res@lbLabelBarOn = False   ; turn off the label bar
  res@lbOrientation          = "vertical"
  res@lbLabelFontHeightF  = 0.025              ; make labels smaller
  res@lbLabelStride = 1
  res@mpFillOn   = True;False     ; turn off gray continents
  res@mpGeophysicalLineThicknessF = 2
  res@mpGeophysicalLineColor      = "black";"white" 
  ;res@mpCenterLonF = 180.
  res@mpMaxLatF  = 63.
  res@mpMinLatF  = 30.
  res@mpMaxLonF  = 140.
  res@mpMinLonF  = 80.
 ; now change the size of the tickmark labels
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
;-------------------------------------------------------------------
  res3                  = True       ; use plot options
  res3@cnFillOn         = False;True       ; Fill contours
  res3@cnLinesOn        = True      ; turn off contour lines
;for tp masking
  res3@gsnFrame         = False
  res3@gsnDraw  = False 
  res3@cnLineLabelsOn   = False      ; turn off contour line labels
  res3@cnLineThicknessF = 7
  res3@cnLineColor      = "green"
  res3@cnInfoLabelOn = False
  res3@cnLevelSelectionMode="ExplicitLevels"
  res3@cnLevels = (/118./)
  res3@gsnLeftString      = " "
  res3@gsnRightString      = " "   
;-----------------------------------------------------  
 res@gsnLeftString = "(a)ERA5"
 res@gsnCenterString = " "
 plot(0) = gsn_csm_contour_map_ce(wks,ps_e_m,res) ; create a default plot

 res@gsnLeftString = "(b)amip"
 res@gsnCenterString = " "
 plot(1) = gsn_csm_contour_map_ce(wks,ps_m,res) ; create a default plot

 res@gsnLeftString = "(c)amip_NMO"
 res@gsnCenterString = " "
 plot(2) = gsn_csm_contour_map_ce(wks,ps_nmo_m,res)

 res@gsnLeftString = "(d)amip_NS_MO"
 res@gsnCenterString = " "
 plot(3) = gsn_csm_contour_map_ce(wks,ps_ns_m,res) 
 
;**************************************************
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
vecres@vcFillArrowHeadInteriorXF = 0.3
vecres@vcFillArrowHeadYF         = 0.25
vecres@vcFillArrowEdgeThicknessF = 0.05
vecres@vcMonoFillArrowEdgeColor = -1

;  plot_uv(0) = gsn_csm_vector(wks,u_e_m(36,:,:),v_e_m(36,:,:),vecres)
;  plot_uv(1) = gsn_csm_vector(wks,newu_m(0,:,:),newv_m(0,:,:),vecres)
;  plot_uv(2) = gsn_csm_vector(wks,newunmo_m(0,:,:),newvnmo_m(0,:,:),vecres)
;  plot_uv(3) = gsn_csm_vector(wks,newuns_m(0,:,:),newvns_m(0,:,:),vecres)

 plot_uv(0) = gsn_csm_vector(wks,u_e_m(36,:,:),v_e_m(36,:,:),vecres)
 plot_uv(1) = gsn_csm_vector(wks,hisu_m(0,:,:),hisv_m(0,:,:),vecres)
 plot_uv(2) = gsn_csm_vector(wks,hisunmo_m(0,:,:),hisvnmo_m(0,:,:),vecres)
 plot_uv(3) = gsn_csm_vector(wks,hisuns_m(0,:,:),hisvns_m(0,:,:),vecres)


plot_mp(0) = gsn_csm_contour(wks,v({30:70},{80:140}),res3)
plot_mp(1) = gsn_csm_contour(wks,v({30:70},{80:140}),res3)
plot_mp(2) = gsn_csm_contour(wks,v({30:70},{80:140}),res3)
plot_mp(3) = gsn_csm_contour(wks,v({30:70},{80:140}),res3)

plot_orog(0) = gsn_csm_contour(wks,o_a, res2)
plot_orog(1) = gsn_csm_contour(wks,o_a, res2)
plot_orog(2) = gsn_csm_contour(wks,o_nmo , res2)
plot_orog(3) = gsn_csm_contour(wks,o_ns, res2)

overlay(plot(0), plot_orog(0))
overlay(plot(1), plot_orog(1))
overlay(plot(2), plot_orog(2))
overlay(plot(3), plot_orog(3))

overlay(plot(0),plot_mp(0))
overlay(plot(1),plot_mp(1))
overlay(plot(2),plot_mp(2))
overlay(plot(3),plot_mp(3))

overlay(plot(0),plot_uv(0))
overlay(plot(1),plot_uv(1))
overlay(plot(2),plot_uv(2))
overlay(plot(3),plot_uv(3))

;************************************************
; create panel
;************************************************
resP                     = True                ; modify the panel plot
                                               ; new resource added in NCL V6.4.0

resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.015               ; make labels smaller
resP@lbOrientation          = "horizontal"     ;"vertical"

gsn_panel(wks,plot,(/2,2/),resP)


end