load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin

tf      = addfile("/data4/2023xunuo/MongoliaData/data/amip/day/ta/gr/v20231215/ta_amip_day_19790101-20201231.ydaymean.nc", "r")    ; file references (pointers)
uf      = addfile("/data4/2023xunuo/MongoliaData/data/amip/day/ua/gr/v20231215/ua_amip_day_19790101-20201231.ydaymean.nc", "r")
vf      = addfile("/data4/2023xunuo/MongoliaData/data/amip/day/va/gr/v20231215/va_amip_day_19790101-20201231.ydaymean.nc", "r")
tf_nmo  = addfile("/data4/2023xunuo/MongoliaData/data/amip-NMO/day/ta/gr/v20231215/ta_amip-NMO_day_19790101-20201231.ydaymean.nc", "r")    ; file references (pointers)
uf_nmo  = addfile("/data4/2023xunuo/MongoliaData/data/amip-NMO/day/ua/gr/v20231215/ua_amip-NMO_day_19790101-20201231.ydaymean.nc", "r")
vf_nmo  = addfile("/data4/2023xunuo/MongoliaData/data/amip-NMO/day/va/gr/v20231215/va_amip-NMO_day_19790101-20201231.ydaymean.nc", "r")
tf_ns   = addfile("/data4/2023xunuo/MongoliaData/data/amip-NS_MO/day/ta/gr/v20231215/ta_amip_NS_MO_day_19790101-20201231.ydaymean.nc", "r")
uf_ns   = addfile("/data4/2023xunuo/MongoliaData/data/amip-NS_MO/day/ua/gr/v20231215/ua_amip_NS_MO_day_19790101-20201231.ydaymean.nc", "r")
vf_ns   = addfile("/data4/2023xunuo/MongoliaData/data/amip-NS_MO/day/va/gr/v20231215/va_amip_NS_MO_day_19790101-20201231.ydaymean.nc", "r")

t1=tf->ta
hist1=t1(:,::-1,:,:)
u1=uf->ua
hisu1=u1(:,::-1,:,:)
v1=vf->va
hisv1=v1(:,::-1,:,:)

t2=tf_nmo->ta
hist2=t2(:,::-1,:,:)
u2=uf_nmo->ua
hisu2=u2(:,::-1,:,:)
v2=vf_nmo->va
hisv2=v2(:,::-1,:,:)

t3=tf_ns->ta
hist3=t3(:,::-1,:,:)
u3=uf_ns->ua
hisu3=u3(:,::-1,:,:)
v3=vf_ns->va
hisv3=v3(:,::-1,:,:)

n=addfile("/data12/data_open/FGOALS-f2-L/heb_AMIP70.famil.ver.nc","r")
hyam = n->hyam   ;from top to bottom in vinth2p funciton
hybm = n->hybm ; so convert level
p1 = addfile("/data12/CMIP6/FGOALS-f3-L/CMIP/CAS/FGOALS-f3-L/amip/r1i1p1f1/Amon/ta/gr/v20190422/ta_Amon_FGOALS-f3-L_amip_r1i1p1f1_gr_197901-201412.nc","r")
leee = p1->plev
levv = leee 
levv = leee/ 100.0
p2 = addfile("/data4/2023xunuo/MongoliaData/data/amip/day/ps/gr/v20231215/ps_amip_ydaymean_19790101-20201231.nc","r")
PS = p2->ps
p2_nmo = addfile("/data4/2023xunuo/MongoliaData/data/amip-NMO/day/ps/gr/v20231215/ps_amip-NMO_ydaymean_19790101-20201231.nc","r")
PS_nmo = p2_nmo->ps
p2_ns = addfile("/data4/2023xunuo/MongoliaData/data/amip-NS_MO/day/ps/gr/v20231215/ps_amip_NS_MO_day_19790101-20201231.ydaymean.nc","r")
PS_ns = p2_ns->ps
levv@units="hPa"

newu_a =vinth2p(hisu1, hyam, hybm, levv, PS, 1, 1000., 1, False)
newv_a =vinth2p(hisv1, hyam, hybm, levv, PS, 1, 1000., 1, False)
newt_a =vinth2p(hist1, hyam, hybm, levv, PS, 1, 1000., 1, False)
newu_nmo =vinth2p(hisu2, hyam, hybm, levv, PS_nmo, 1, 1000., 1, False)
newv_nmo =vinth2p(hisv2, hyam, hybm, levv, PS_nmo, 1, 1000., 1, False)
newt_nmo =vinth2p(hist2, hyam, hybm, levv, PS_nmo, 1, 1000., 1, False)
newu_ns =vinth2p(hisu3, hyam, hybm, levv, PS_ns, 1, 1000., 1, False)
newv_ns =vinth2p(hisv3, hyam, hybm, levv, PS_ns, 1, 1000., 1, False)
newt_ns =vinth2p(hist3, hyam, hybm, levv, PS_ns, 1, 1000., 1, False)

TIME    = uf->time                  ; all times on file: "hours since ..."

U       = newu_a   ;double
V       = newv_a  ;
T       = newt_a     ; 
U_nmo       = newu_nmo   ;double
V_nmo       = newv_nmo  ;
T_nmo       = newt_nmo
U_ns       = newu_ns   ;double
V_ns       = newv_ns  ;
T_ns       = newt_ns

lat     = uf->lat  
plvl    = doubletofloat(levv) 
sf      =    5.0        ; tofloat(getenv("sc_fact_start"))

opt     = True          
opt@magf= sf            ; make NCL attribute for use by 'epflux'

print("cal epflux")
epf     =  epflux(U,V,T,plvl,lat,False)
epf_nmo =  epflux(U_nmo,V_nmo,T_nmo,plvl,lat,False)
epf_ns =  epflux(U_ns,V_ns,T_ns,plvl,lat,False)

Fphi  = epf[0]          ; extract variables from 'list' for clarity
Fp    = epf[1]
EPdiv = epf[2]
dudt  = epf[3]
delete(epf) 
Fphi_nmo  = epf_nmo[0]          ; extract variables from 'list' for clarity
Fp_nmo    = epf_nmo[1]
EPdiv_nmo = epf_nmo[2]
dudt_nmo  = epf_nmo[3]   
delete(epf_nmo)           ; delete list variable; no longer needed
Fphi_ns  = epf_ns[0]          ; extract variables from 'list' for clarity
Fp_ns    = epf_ns[1]
EPdiv_ns = epf_ns[2]
dudt_ns  = epf_ns[3]   
delete(epf_ns)  

 printVarSummary(Fphi)
 printMinMax(Fphi, 0)
 print("+++")
 printVarSummary(Fp)
 printMinMax(Fp, 0)
 print("+++")
 printVarSummary(EPdiv)
 printMinMax(EPdiv(:,{0:70}), 0)
 print("+++")
 printVarSummary(dudt)
 printMinMax(dudt(:,{0:70}), 0)
 print("+++")

; printVarSummary(Fphi_nmo)
; printMinMax(Fphi_nmo, 0)
; print("+++")
; printVarSummary(Fp_nmo)
; printMinMax(Fp_nmo, 0)
; print("+++")
; printVarSummary(EPdiv_nmo)
; printMinMax(EPdiv_nmo(:,{0:70}), 0)
; print("+++")
; printVarSummary(dudt_nmo)
; printMinMax(dudt_nmo(:,{0:70}), 0)
; print("+++")
;*****************************************************************************************
tf_ERA5      = addfile("/data4/2023xunuo/ERA5/day/temp/temp.19790101-20201231_365.ydaymean.360x180.nc", "r")    ; file references (pointers)
uf_ERA5      = addfile("/data4/2023xunuo/ERA5/day/uwind/uwind.19790101-20201231_365.ydaymean.360x180.nc", "r")
vf_ERA5      = addfile("/data4/2023xunuo/ERA5/day/vwind/vwind.19790101-20201231_365.ydaymean.360x180.nc", "r")

U_E      = uf_ERA5->u  ; m/s(iStrt:iLast,:,:,:)short2flt
V_E      = vf_ERA5->v  ;(iStrt:iLast,:,:,:)short2flt
T_E      = tf_ERA5->t     ; degK(iStrt:iLast,:,:,:)short2flt

U_ERA5=U_E(:,::-1,:,:) 
V_ERA5=V_E(:,::-1,:,:) 
T_ERA5=T_E(:,::-1,:,:) 


printVarSummary(U_ERA5)
printVarSummary(T_ERA5)

printMinMax(T_ERA5,0)
printMinMax(V_ERA5,0)
printMinMax(U_ERA5,0)

lat_ERA5     = uf_ERA5->lat
plvl_ERA5    = doubletofloat(uf_ERA5->level(::-1)) 
sf      =    5.0        ; tofloat(getenv("sc_fact_start"))

opt     = True          
opt@magf= sf            ; make NCL attribute for use by 'epflux'

print("cal epflux")
epf_ERA5     =  epflux(U_ERA5,V_ERA5,T_ERA5,plvl_ERA5,lat_ERA5,False)   

Fphi_ERA5  = epf_ERA5[0]          ; extract variables from 'list' for clarity
Fp_ERA5    = epf_ERA5[1]
EPdiv_ERA5 = epf_ERA5[2]
dudt_ERA5  = epf_ERA5[3]
delete(epf_ERA5)    

; printVarSummary(Fphi_ERA5)
; printMinMax(Fphi_ERA5, 0)
; print("+++")
; printVarSummary(Fp_ERA5)
; printMinMax(Fp_ERA5, 0)
; print("+++")
; printVarSummary(EPdiv_ERA5)
; printMinMax(EPdiv_ERA5(:,{0:70}), 0)
; print("+++")
; printVarSummary(dudt_ERA5)
; printMinMax(dudt_ERA5(:,{0:70}), 0)
; print("+++")

;*****************************************************************************************************************
wks=gsn_open_wks("pdf", "EP")
plotvec=new((/4/),graphic)   
plotcon=new((/4/),graphic)   
;******************************************************************************************************************
  res_vec = True
  res_vec@gsnMaximize           = False              ;最大页面化
  res_vec@gsnDraw               = False             ; allows for manual overlaying        
  res_vec@gsnFrame              = False        
  res_vec@vfXArray              = lat               ; use lat for x axis
  res_vec@vfYArray              = plvl              ; use pressure for y axis
  res_vec@trYReverse            = True              ; reverse y-axis
  res_vec@gsnYAxisIrregular2Log = True              ; set y-axis to log scale
  ;res_vec@tiXAxisString         = "latitude"        ; x-axis label
  res_vec@tiYAxisString         = "Level(hPa)"   ; y-axis label
  res_vec@tiXAxisFontHeightF    = 0.0175
  res_vec@tiYAxisFontHeightF    = 0.0175
  res_vec@vcMinDistanceF        =0.02                  ;箭头之间最小距离
  res_vec@vcPositionMode        ="ArrowTail"           ;箭头的尾端点对齐网格点
  res_vec@vcRefAnnoOn           = True              ; turn off ref wind barb 参考箭头
  res_vec@vcRefAnnoFontHeightF  =0.015              ;参考箭头标签字体大小
  res_vec@vcRefAnnoPerimOn      =False              ;边框
  ;res_vec@vcRefAnnoSide        ="Bottom" 
  res_vec@vcRefMagnitudeF       = 20                ;参考箭头所表示实际物理量的值
  res_vec@vcRefLengthF          =0.055               ;参考箭头在图形中的长度
  res_vec@vcRefAnnoString1On    =False              ;参考箭头上的字符串
  res_vec@vcRefAnnoString2On    =True               ;参考箭头下的字符串
  res_vec@vcRefAnnoString2      ="20"
  ;res_vec@vcRefAnnoBackgroundColor  =-1              ;参考箭头背景色设为透明
  res_vec@vcRefAnnoOrientation = "Horizontal"
  res_vec@vcGlyphStyle           ="LineArrow"      ;填充箭头样式
;   res_vec@vcFillArrowHeadXF      =0.2
;   res_vec@vcFillArrowHeadYF      =0.05
;   res_vec@vcFillArrowHeadInteriorXF   =0.05
;   res_vec@vcFillArrowWidthF           =0.02
;   res_vec@vcFillArrowFillColor        ="black"
;   res_vec@vcFillArrowEdgeColor        ="Black"
  res_vec@vcLineArrowThicknessF       =2.0
  res_vec@vcLevelSelectionMode  = "ExplicitLevels"
  ;res_vec@vcLevelSpacingF       = 25.0
;   res_vec@vcMinLevelValF        = 0.0
;   res_vec@vcMaxLevelValF        = 400.0
  res_vec@pmLabelBarDisplayMode = "Never"          ; Turn on a label bar.
  res_vec@pmLabelBarWidthF      = 0.08              ; make it thinner
  res_vec@lbPerimOn             = False             ; no box around it
  res_vec@lbLabelBarOn       =False
  ;res_vec@tiMainString          = vectitle          ; plot title
  res_vec@tiMainFontHeightF     = 0.0185
  res_vec@tmXBLabelFontHeightF  = 0.0125
  res_vec@tmYLLabelFontHeightF  = 0.0125
  res_vec@tmXBMajorLengthF      = -0.0075           ; minus mean outward face
  res_vec@tmYLMajorLengthF      = -0.0075           ; minus mean outward face
  res_vec@trXMinF=0
  res_vec@trXMaxF=70
  res_vec@tmYLMode              = "Explicit"        ; Pressure (YL) axis
  res_vec@tmYROn      =False
  res_vec@tmYLMode     = "Explicit"
  res_vec@tmYLValues   =(/1000,400,200,100,50,30,10/)
  res_vec@tmYLLabels   =(/"1000","400","200","100","50","30","10"/)
  res_vec@vpWidthF              = 0.60              ; shape
  res_vec@vpHeightF             = 0.35
  res_vec@tmXBMode     = "Explicit"
  res_vec@tmXBValues   =(/0,10,20,30,40,50,60,70/)
  res_vec@tmXBLabels   =(/"0","10~S~o~N~N","20~S~o~N~N","30~S~o~N~N","40~S~o~N~N","50~S~o~N~N","60~S~o~N~N","70~S~o~N~N"/)
;*************************************************************************************
res_con1                       = True
res_con1@gsnDraw               = False
res_con1@gsnFrame              = False
res_con1@gsnMaximize           = False          
res_vec@vfXArray              = lat               ; use lat for x axis
res_vec@vfYArray              = plvl              ; use pressure for y axis
res_con1@trYReverse            = True               ; reverse y-axis
res_con1@cnFillOn              =True
res_con1@cnLinesOn             =False
res_con1@cnLineLabelsOn        =False
res_con1@cnFillPalette         ="BlueDarkRed18"
res_con1@cnLevelSelectionMode   = "ManualLevels"        ; set manual contour levels
res_con1@cnMaxLevelValF        =  500          ; set max contour level
res_con1@cnMinLevelValF        =  -500              ; set min contour level
res_con1@cnLevelSpacingF       =  50.                 ; set contour interval
;res_con1@cnLineColor           = "black"      
;res_con1@cnLineThicknessF      = 2.0               ; default is 1.0
res_con1@trXMinF=0
res_con1@trXMaxF=70
res_con1@tiYAxisString     ="Level(hPa)"
res_con1@tmYROn      =False
res_con1@tmXBMode     = "Explicit"
res_con1@tmXBValues   =(/0,10,20,30,40,50,60,70/)
res_con1@tmXBLabels   =(/"0","10~S~o~N~N","20~S~o~N~N","30~S~o~N~N","40~S~o~N~N","50~S~o~N~N","60~S~o~N~N","70~S~o~N~N"/)
res_con1@tmYLMode     = "Explicit"
res_con1@tmYLValues   =(/1000,850,700,500,400,300/)      ;(/1000,400,200,100,50,30,10/)
res_con1@tmYLLabels   = (/"1000","850","700","500","400","300"/)                    ;(/"1000","400","200","100","50","30","10"/)
res_con1@trYMinF=300
res_con1@trYMaxF=1000
res_con1@gsnYAxisIrregular2Log = True               ; set y-axis to log scale
; res_con1@gsnContourZeroLineThicknessF = 0.0
; res_con1@gsnContourPosLineDashPattern = 2
;res_con@gsnContourNegLineDashPattern = 2
res_con1@cnInfoLabelOn        =False
res_con1@cnSmoothingOn         = True
 res_con1@lbLabelBarOn            = False                                 ; turn off the label bar
 res_con1@lbOrientation          = "Vertical"
 res_con1@pmLabelBarWidthF       =0.1                              
 res_con1@pmLabelBarHeightF      =0.6                                 
 res_con1@lbLabelFontHeightF  = 0.015                               ; make labels smaller
 res_con1@lbLabelStride = 1                                         
;******************************************************************************************************************
res_vec@gsnLeftString = "(a)ERA5"
;res_vec@tiYAxisString = "Level(hPa)"   
res_vec@gsnLeftStringFontHeightF    =0.02
res_vec@gsnCenterString = " "
plotvec(0) = gsn_csm_vector(wks,Fphi_ERA5,Fp_ERA5,res_vec)

res_vec@gsnLeftString = "(b)amip"
;res_vec@tiYAxisString  = " "   
res_vec@gsnLeftStringFontHeightF    =0.02
res_vec@gsnCenterString = " "
plotvec(1) = gsn_csm_vector(wks,Fphi,Fp,res_vec)

res_vec@gsnLeftString = "(c)amip_NMO"
;res_vec@tiYAxisString = "Level(hPa)"   
res_vec@gsnLeftStringFontHeightF    =0.02
res_vec@gsnCenterString = " "
plotvec(2) = gsn_csm_vector(wks,Fphi_nmo,Fp_nmo,res_vec)

res_vec@gsnLeftString = "(d)amip_NS_MO"
;res_vec@tiYAxisString  = " "  
res_vec@gsnLeftStringFontHeightF    =0.02
res_vec@gsnCenterString = " "
plotvec(3) = gsn_csm_vector(wks,Fphi_ns,Fp_ns,res_vec)

res_con1@gsnLeftString = " "
res_con1@gsnCenterString = " "
plotcon(0) = gsn_csm_contour(wks,EPdiv_ERA5,res_con1) 

res_con1@gsnLeftString = " "
res_con1@gsnCenterString = " "
plotcon(1) = gsn_csm_contour(wks,EPdiv,res_con1)

res_con1@gsnLeftString = " "
res_con1@gsnCenterString = " "
plotcon(2) = gsn_csm_contour(wks,EPdiv_nmo,res_con1)

res_con1@gsnLeftString = " "
res_con1@gsnCenterString = " "
plotcon(3) = gsn_csm_contour(wks,EPdiv_ns,res_con1)

overlay(plotcon(0),plotvec(0))
overlay(plotcon(1),plotvec(1))
overlay(plotcon(2),plotvec(2))
overlay(plotcon(3),plotvec(3))

resP                     = True                ; modify the panel plot
resP@gsnPanelLabelBar    = True                ; add common colorbar
resP@lbLabelFontHeightF  = 0.015               ; make labels smaller
resP@pmLabelBarWidthF       =0.6                               
resP@pmLabelBarHeightF      =0.06                                
resP@lbLabelStride = 2                                         
resP@lbOrientation          = "Horizontal"     ;"vertical"

gsn_panel(wks,plotcon,(/2,2/),resP)

print ( "done" )
end
