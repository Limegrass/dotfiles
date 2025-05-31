#! /bin/sh

# Generically assign all pointer devices that are wireless receivers (wireless mice) to no accel
# HSK Pro: pointer-13284-22535-Beijing_Jingyunmake_Technology_Co.,_Ltd._G-Wolves_HSK_Pro_4K_Receiver-N
# HSK Plus pointer-13284-170-Compx_2.4G_Wireless_Receiver
# flat = 1:1 response, so no accel
riverctl list-inputs | rg pointer-.*Receiver | xargs -I{} riverctl input {} accel-profile flat;
riverctl list-inputs | rg pointer-.*G-Wolves_.* | xargs -I{} riverctl input {} accel-profile flat;
