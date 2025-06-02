begin
b = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")   ; read in land sea mask basemap file
f1 = addfile("/data4/2023xunuo/MongoliaData/huatu/zg/zg_Amon_amip_197901-202012.nc", "r")
z_a_h = f1->zg
z_a_his=z_a_h(:,::-1,:,:)
n=addfile("/data12/data_open/FGOALS-f2-L/heb_AMIP70.famil.ver.nc","r")
hyam = n->hyam   ;from top to bottom in vinth2p funciton
hybm = n->hybm ; so convert level
p1 = addfile("/data12/CMIP6/FGOALS-f3-L/CMIP/CAS/FGOALS-f3-L/amip/r1i1p1f1/Amon/ta/gr/v20190422/ta_Amon_FGOALS-f3-L_amip_r1i1p1f1_gr_197901-201412.nc","r")
leee = p1->plev
levv = leee 
levv = leee/ 100.0
p2 = addfile("/data4/2023xunuo/MongoliaData/huatu/ps/ps_amip_7901-2012.nc","r")
PS = p2->ps

z_a_new=vinth2p(z_a_his, hyam, hybm, levv, PS, 2, 1000., 1, False)
z_a=z_a_new(:,5,{0:90},{0:180})

f2 = addfile("/data4/2023xunuo/ERA5/monthly/geopotential/ERA5_geopotential_ymonmean_1979-2020_360x180.nc", "r")
z_e = f2->z(:,21,{0:90},{0:180})

zg_a_rm=dim_rmvmean_n_Wrap(z_a, 2)   ; lon mean
zg_e_rm=dim_rmvmean_n_Wrap(z_e, 2)
zg_a_rm_m=dim_avg_n_Wrap(zg_a_rm, 0)  ;time mean
zg_e_rm_m=dim_avg_n_Wrap(zg_e_rm, 0)
zg_a_rm_DJF=month_to_season(zg_a_rm, "DJF")  ;DJF
zg_e_rm_DJF=month_to_season(zg_e_rm, "DJF") 
zg_a_rm_DJF_m=dim_avg_n_Wrap(zg_a_rm_DJF, 0)   ;DJF mean
zg_e_rm_DJF_m=dim_avg_n_Wrap(zg_e_rm_DJF, 0)

gpm_a_rm=zg_a_rm_m
gpm_e_rm=zg_e_rm_m
gpm_e_rm=zg_e_rm_m/9.8
gpm_a_rm_DJF=zg_a_rm_DJF_m
gpm_e_rm_DJF=zg_e_rm_DJF_m
gpm_e_rm_DJF=zg_e_rm_DJF_m/9.8
;***************************************************************
z_a_m=dim_avg_n_Wrap(z_a, 0)    ;time mean 500(lat,,lon)
z_e_m=dim_avg_n_Wrap(z_e, 0)
z_a_lat=dim_avg_n_Wrap(z_a_m, 1)   ;lon mean (lat)
z_e_lat=dim_avg_n_Wrap(z_e_m, 1)

z_a_season=month_to_season(z_a, "DJF")   ;DJF (time,lat,lon)
z_e_season=month_to_season(z_e, "DJF")
z_a_season_m=dim_avg_n_Wrap(z_a_season, 0) ;DJF mean (lat,lon)
z_e_season_m=dim_avg_n_Wrap(z_e_season, 0)
z_a_season_lat=dim_avg_n_Wrap(z_a_season_m, 1)   ;lon DJF mean (lat)
z_e_season_lat=dim_avg_n_Wrap(z_e_season_m, 1)

zg_a_m=z_a_m
zg_e_m=z_e_m/9.8

ndim=0
z_a_l=conform_dims(dimsizes(z_a_m), z_a_lat, ndim)
z_e_l=conform_dims(dimsizes(z_e_m), z_e_lat, ndim)

z_a_s_l=conform_dims(dimsizes(z_a_season_m), z_a_season_lat, ndim)
z_e_s_l=conform_dims(dimsizes(z_e_season_m), z_e_season_lat, ndim)

gpm_a=z_a_m
gpm_a=z_a_m-z_a_l
gpm_e=z_e_m
gpm_e=(z_e_m-z_e_l)/9.8

gpm_a_DJF = z_a_season_m
gpm_a_DJF = z_a_season_m - z_a_s_l
gpm_e_DJF = z_e_season_m
gpm_e_DJF = (z_e_season_m - z_e_s_l)/9.8
;************************************************************
fu1=addfile("/data4/2023xunuo/MongoliaData/huatu/ua/ua_amip_7901-2012.nc", "r")
 u_amip_his=fu1->ua
 lev_u_a=fu1->lev
 lev_u_amip=lev_u_a(::-1)
 u_amip_h=u_amip_his(:,::-1,:,:)

fv1=addfile("/data4/2023xunuo/MongoliaData/huatu/va/va_amip_7901-2012.nc", "r")
 v_amip_his=fv1->va
 lev_v_a=fv1->lev
 lev_v_amip=lev_v_a(::-1)
 v_amip_h=v_amip_his(:,::-1,:,:)

fu2=addfile("/data4/2023xunuo/MongoliaData/huatu/ua/ua_amip-NMO_7901-2012.nc","r")
 u_nmo_his=fu2->ua
 lev_u_n=fu2->lev
 lev_u_nmo=lev_u_n(::-1)
 u_nmo_h=u_nmo_his(:,::-1,:,:)

fv2=addfile("/data4/2023xunuo/MongoliaData/huatu/va/va_amip-NMO_7901-2012.nc","r")
 v_nmo_his=fv2->va
 lev_v_n=fv2->lev
 lev_v_nmo=lev_v_n(::-1)
 v_nmo_h=v_nmo_his(:,::-1,:,:)


 u_a =vinth2p(u_amip_h, hyam, hybm, levv, PS, 1, 1000., 1, False)
 u_n =vinth2p(u_nmo_h, hyam, hybm, levv, PS, 1, 1000., 1, False)
 v_a =vinth2p(v_amip_h, hyam, hybm, levv, PS, 1, 1000., 1, False)
 v_n =vinth2p(v_nmo_h, hyam, hybm, levv, PS, 1, 1000., 1, False)

 u_amip=u_a(:,5,:,:);{0:90},{0:180})
 u_nmo=u_n(:,5,:,:);{0:90},{0:180})
 v_amip=v_a(:,5,:,:);{0:90},{0:180})
 v_nmo=u_n(:,5,:,:);{0:90},{0:180})

 u_amip_DJF=month_to_season(u_amip, "DJF")
 u_nmo_DJF=month_to_season(u_nmo, "DJF")

 v_amip_DJF=month_to_season(v_amip, "DJF")
 v_nmo_DJF=month_to_season(v_nmo, "DJF")


 u_amip_DJF_m=dim_avg_n_Wrap(u_amip_DJF, 0)
 u_nmo_DJF_m=dim_avg_n_Wrap(u_nmo_DJF, 0)

 v_amip_DJF_m=dim_avg_n_Wrap(v_amip_DJF, 0)
 v_nmo_DJF_m=dim_avg_n_Wrap(v_nmo_DJF, 0)


fue=addfile("/data4/2023xunuo/ERA5/monthly/uv/u_component_of_wind/ERA5_u_ymonmean_1979-2020_360*180.nc", "r")
u_e=fue->u(:,21,:,:);{0:90},{0:180})
u_e_DJF=month_to_season(u_e, "DJF")
u_e_DJF_m=dim_avg_n_Wrap(u_e_DJF, 0)

fve=addfile("/data4/2023xunuo/ERA5/monthly/uv/v_component_of_wind/ERA5_v_ymonmean_1979-2020_360*180.nc", "r")
v_e=fve->v(:,21,:,:);{0:90},{0:180})
v_e_DJF=month_to_season(v_e, "DJF")
v_e_DJF_m=dim_avg_n_Wrap(v_e_DJF,0)
;******************************************************************
wks = gsn_open_wks("pdf","zg-uv_500hPa")  ; open a ps file
plot_zg=new((/2/),graphic)
plot_uv=new((/2/),graphic)
;***************************************************************
res1                  = True       ; use plot options
 res1@cnFillOn         = True    ; Fill contours
 res1@cnLinesOn        = False      ; turn off contour lines  
 res1@gsnFrame         = False
 res1@gsnDraw          = False 
 res1@cnLineLabelsOn   = False      ; turn off contour line labels
 res1@cnLineThicknessF = 3           ;粗细
 res1@cnLineColor      = "black"
 res1@cnInfoLabelOn    = False
 res1@cnFillPalette          ="GMT_polar";"hotcold_18lev"  ;"BlueDarkRed18" ; "amwg"  "cmp_flux" ; set color map
 res1@cnFillMode             ="AreaFill"
 res1@cnLevelSelectionMode="ManualLevels"
 res1@cnMaxLevelValF      = 180
 res1@cnMinLevelValF      = -180
 res1@cnLevelSpacingF     = 20
 res1@cnFillMode            ="AreaFill"
 res1@gsnLeftString      = " "
 res1@gsnRightString      = " "
 res1@gsnSpreadColors            = False  
 res1@lbLabelBarOn            = False                                 ; turn off the label bar
 res1@lbOrientation          = "Horizontal"
 res1@lbLabelFontHeightF  = 0.025                               ; make labels smaller
 res1@lbLabelStride = 2
 res1@pmLabelBarWidthF       =0.6                               ;色标宽度
 res1@pmLabelBarHeightF      =0.08                                 ;色标高度
 res1@pmLabelBarOrthogonalPosF=  0.3                               ;色标垂直方向位置
 res1pmLabelBarParallelPosF  =0.5  
 res1@cnLabelDrawOrder    ="PostDraw"
 res1@cnLineLabelAngleF   =0.0
 res1@cnLineLabelFontHeightF =0.01
 res1@cnLineLabelFontThicknessF =0.8
 res1@cnLineLabelBackgroundColor="-1"
 res1@cnLineLabelDensityF =1.5
 res1@cnLineLabelInterval =1
 res1@cnInfoLabelOn       =False
 ;res1@mpCenterLonF=180
 res1@mpMaxLatF  = 90
 res1@mpMinLatF  = 0
 res1@mpMaxLonF  = 180
 res1@mpMinLonF  = 0
 res1@mpFillOn=True
 res1@mpFillColor="white"
 res1@mpOutlineOn=True
 res1@mpGeophysicalLineColor="black"
 res1@mpInlandWaterFillColor=0
 res1@mpLandFillColor=0
 res1@mpMonoFillColor=True
 res1@mpOceanFillColor=0
 res1@mpGeophysicalLineDashPattern=0
 res1@mpGeophysicalLineThicknessF=2
 res1@tmXBTickSpacingF = 20
 res1@tmYLTickSpacingF = 20
 res1@tmXBLabelFontHeightF = 0.025
 res1@tmXBLabelFontThicknessF = 2.0
 res1@tmYLLabelFontHeightF = 0.025
 res1@tmYLLabelFontThicknessF = 2.0
 ;res1@tiYAxisString="500hPa"
;*******************************************************************
vecres                  = True            ; vector only resources
  vecres@gsnDraw          = False           ; don't draw
  vecres@gsnFrame         = False           ; don't advance frame
  vecres@vcGlyphStyle     = "LineArrow"   ; curly vectors
  vecres@vcFillArrowEdgeColor="black"
  vecres@vcFillArrowFillColor="black"
  vecres@vcRefMagnitudeF  = 20              ; define vector ref mag
  vecres@vcRefLengthF     = 0.03            ; define length of vec ref
  vecres@gsnRightString   = " "             ; turn off right string
  vecres@gsnLeftString    = " "             ; turn off left string
  vecres@tiXAxisString    = " "             ; turn off axis label 
  vecres@vcRefAnnoOrthogonalPosF = -0.12     ; move ref vector into plot
  vecres@vcRefAnnoOn      = True            ; draw the reference vector annotation.
  vecres@vcRefAnnoString2On = True          ;display a string below or to the right 
  vecres@vcRefAnnoString1  = "20 m/s"
  vecres@vcRefAnnoString2  = "" 
  vecres@vcRefAnnoPerimThicknessF  ="0.045"
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
  vecres@vcFillArrowMinFracWidthF  = 1.0
  vecres@vcFillArrowHeadMinFracXF  = 1.0
  vecres@vcFillArrowHeadMinFracYF  = 1.0
  vecres@vcFillArrowHeadXF         = 0.6
  vecres@vcFillArrowHeadInteriorXF = 0.3
  vecres@vcFillArrowHeadYF         = 0.25
  vecres@vcFillArrowEdgeThicknessF = 0.045
  vecres@vcMonoFillArrowEdgeColor = -1
;*********************************************************************
 res1@gsnLeftString = "(a)ERA5"
 res1@gsnCenterString = " "
 plot_zg(0) = gsn_csm_contour_map_ce(wks,gpm_e_DJF,res1)

 res1@gsnLeftString = "(b)amip "
 res1@gsnCenterString = " "
 plot_zg(1) = gsn_csm_contour_map_ce(wks,gpm_a_DJF,res1) ; create a default plot

 vecres@gsnLeftString = ""
 vecres@gsnCenterString = " "
 plot_uv(0) = gsn_csm_vector(wks,u_e_DJF_m,v_e_DJF_m,vecres)

 vecres@gsnLeftString = ""
 vecres@gsnCenterString = " "
  plot_uv(1) = gsn_csm_vector(wks,u_amip_DJF_m,v_amip_DJF_m,vecres)

;**********************************
 overlay(plot_zg(0), plot_uv(0))
 overlay(plot_zg(1), plot_uv(1))

 resP                     = True                ; modify the panel plot
 resP@gsnPanelLabelBar    = True                ; add common colorbar
 resP@lbLabelFontHeightF  = 0.015               ; make labels smaller
 resP@pmLabelBarWidthF       =0.6                               
 resP@pmLabelBarHeightF      =0.06                               
 resP@lbLabelStride = 2                                         
 resP@lbOrientation          = "horizontal"     ;"vertical"

   gsn_panel(wks,plot_zg,(/2,1/),resP)

end

