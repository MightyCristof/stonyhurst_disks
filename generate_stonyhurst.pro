;-----------------------------------------------------------------------------------------
; NAME:                                                                      IDL Procedure
;   generate_stonyhurst
;
; PURPOSE:
;   Create Stonyhurst Disks for each month of the year.
;   
; CALLING SEQUENCE:
;   generate_stonyhurst, pixlen
;   
; INPUTS:
;   pixlen          - Scalar length of the desired overlay image in pixels.
;   
; OPTIONAL INPUTS:
;   
; OUTPUTS:
;   
; OPTIONAL OUTPUTS:
;   
; COMMENTS:
;   Font size scales with image size.
;   
; EXAMPLES:
;   IDL> generate_stonyhurst,2048
;   
; PROCEDURES CALLED:
;   
; REVISION HISTORY:
;   2017-Jun-23  Written by Christopher M. Carroll (Dartmouth)
;-----------------------------------------------------------------------------------------
;;http://solar-center.stanford.edu/solar-images/latlong.html
PRO generate_stonyhurst, pixlen
                                

;; directory for images
file_mkdir,'overlays'
pushd,'overlays'
;; major and minor grid line size in degrees
major_grid = 10.
minor_grid = 1.
;; month and latitude tilt as string and integer
month = ['01_jan','02_feb','03_mar','04_apr','05_may','06_jun','07_jul','08_aug','09_sep','10_oct','11_nov','12_dec']
lat_offstr = ['-5','-7','-7','-6','-3','+1','+4','+7','+7','+6','+3','-1']
lat_offset = fix(lat_offstr)
;; longitude label position bump (0.5 = "center") to drive it toward the solar equator 
pos = [0.535,0.545,0.545,0.5375,0.52,0.49,0.4625,0.455,0.455,0.4625,0.48,0.51]

for i = 0,n_elements(month)-1 do begin
    ;; create spherical map with equator offset
    mp = map('Orthographic',center_latitude=lat_offset[i], $
             grid_latitude=major_grid,grid_longitude=major_grid, $
             label_show=0,thick=2,transparency=50,font_size=0.0117188*pixlen,font_style='bold', $
             dimensions=[pixlen,pixlen],/buffer)
    ;; add desired axis labels
    foreach lon, mp[['Lon 60W','Lon 30W','Lon 30E','Lon 60E']] do lon.label_show = 1
    foreach lat, mp[['Lat 60N','Lat 30N','Lat 0N','Lat 30S','Lat 60S']] do lat.label_show = 1
    ;; ensure the outer edge of disk doesn't disappear - this happens with axial tilts and thin lines
    mp.mapgrid.horizon_thick = 2
    mp.mapgrid.horizon_color = 'grey'
    ;; offset longitude labels
    mp['Longitudes'].label_position = pos[i]
    ; overplot minor map grid
    grid = MAPGRID(TRANSPARENCY=90, $
                   LONGITUDE_MIN=-90, LONGITUDE_MAX=90, $
                   LATITUDE_MIN=-90, LATITUDE_MAX=90, $
                   GRID_LONGITUDE=1, GRID_LATITUDE=1, $
                   LABEL_SHOW=0)          
    ;; add solar coordinates and save
    t = text(0.39,0.96,'Solar Coordinates: '+lat_offstr[i]+'$\circ$',font_size=0.0175781*pixlen,/relative)
    mp.save,'solar_overlay_'+month[i]+'.jpg'
endfor
popd


END






