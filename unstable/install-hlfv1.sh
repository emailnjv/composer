ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.11.1
docker tag hyperledger/composer-playground:0.11.1 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� 0Q�Y �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�,���O�	�Ƹ8�0����ڎl�ı�jߌ�(�7
}h٪��mn��lh�Uڻ���.����;��C�L�{pw�K2՞�Fi��	-6�Њ��,EPM�rl�J B`{��av���I���e�=�;#�T�pX�H�T���ew��~ ǿ ���%���2t*�ԡe�Tһ��h-�a�
�c��2�j#�`� Pr:�ᑸ�v�&[�T7���dH�g��l9!�5����.�e����t��x$<{łM4����s�P{�pTA�afr�	-�(��T�	Rµ4LL�2��H�/�r�� �i7�=S�j*��-JGFEjum�4�۳�\c��6[��b(򜹼���8&�_���a�~~�� �)3�ݫrL��([�W�N��6���K�,�Z`�ŲuD��3�ܫI�0�J�v���=��Q�T�U�����#���7�E]�ҡ30�.�J��t�p����HMj�3���:�>��x�	�!��+F������M�?�����P:˳�N�����9��@�j�[��v�m��n�������/����7��Z��w���G�ݡlõ��/��$���u��1)V��*�Z9%�c>\��%����&�9����Y~���˃9�eO�'�.���u�F��l�#���t�v>|n���A�?���i,�Q�C* ��>�Y��x�5޿�2�bѾ��0a&,x�Ӿ����f� xd0����c@֛��Z���]}�&v� ��v��Zx��`Zj_v0���B�$�Nǰ��*��*P�I�D��⼌.��^�z�M'5C�*���$]14w��{�~GM��m���DdWK{�����W՚!�R:j���mW3A(��`{|�	H��q]hҳ� �\�_��Dx��'�����e�a~�E����9���QT"L�1W��Fi�p��OԴ4�:p_p������c�l,Ơt�	�F�����`+�\�8Łӑ�U5�(k��>D�X���z����M�َa�xI}��Cv���&a!`� ��KJm�wؚ<d����i��5�RG�*��=\����m��{�gA�]M�.;�B'��j��qn�q9�:wc�e��Q��4k� ��Z��+<��� �Q#_Il �` Q��PȘ^�c�09n�	���F��)�U�A�0�'�cL��p�9�y�:摔�}I��� �8�е!�������I�`&�v��9�_]Uw�)�io���頁�p��Jt�>ԠlC`C*tT�bـ�My?���9���6��Q� �9��_R~EC�:�6��w����kD��E7��������$��������׈S-���y=[���������Ж�i�p���0g�ǌ�`�����o��u����e�����jc���<��v��]xvR����Yg�g��f���M�z���������g����k@ZY?�5�ҹ���	U��U�*�r�7���_����[veg���c �j�D���%�r3b��K�եr%W*����6�}�w�6pu:?"#�v{�/�_��%0Y`�С�fÛ�D5�����,D,ީ��[����Y5W�J���TO�ͣ����j�/g�0Qz��>`�Ђ{�}Ǆ^='QY�����w��܆���[|� �[b\�H�.("S\��k@�?Ͻ&f)`qY<&::=���"&C�wEG|�;�"�4[ z���/g����sp�h'�G��g5X���Xfc��6�ߗs���<�p��GYf���э��^��gw����f�:�M��i��zF�8�xL���o�νa��O�K�oc���8�n�?����p�p�|�H�����N�7�X~���h�����
�������+�]���=�e; Z�a�LK���h�'�M;L�x�o����� B�V:�C�쑺g�Jb�α��{ G!���A�<c!2��O7z_�Q����a�N�)2jZ��n��AYGY�/��:x��������d�������B��Y-���Q�1Zȯʎ�P�b�斻>q�f�y��{X�B�gf�?���X|��9F��~��#{��$ qN�vD{#=L\:x������؉���f�̨nj�B�cz��}����������?��.���Z<��?�"�]�1�n\����_��tA
��+�� ��a���e6�x�̏�'��q�y+���X�.ay���g�E���_`ٍ�����[�?�+"��@ �o` �U���z]d[���"	�";য়�Tʀ�W%������;�K\F'pz�<�լ�W�L^¡��u�	�5B��o|(����6n���p���y�q�T��n�;�Ҍᱬ:U�;1eƇ�T�ota0�E�uE�1�ז1��#۠��Ots�q7!#ߊt~A������e�X`��|L������F��|�d�|�͜{�|n�ƣ&��
�m������.�;�]0Q`έ^�hA*$�r�\O���3�'�d^J��c� P}���,��Đ���),є��p��(ѐ���T�,�JR�LL��R�"֪��T�RUBn�^@=I�r�Ɜ�HG���\ݗ������K�l��=�Ku)������Lù����Ãܙ����Q<)s���a�+��W�T����LL��R>�z�}WgS]��B�,Kս����U��٨"lMջ�	�`�1�R���Ah�5��t�	�s�x�����พyS�;/�S��*����-���i���6�������؍�Ǐ|$w
��v�J�P-�&�ȩ}@�`��6�st�A�t����06�^b�O�C��������bѻ�o/�+�[���䟽WВ����;�M���������R�E����?؍�_|����A��C�W�.
+}E�%$pD��e�:8�z���Ȗ�����7D��Q�;qK B�B �w��m�+��7�)`Y��K��lt��.����������'0{F�5,�kQE^]�z��E髵b�J�٘,s��_V��s)�"����r���[|���ņ �����;h��І�ˣ��	gp���e��>���?�7���?>�m����}��Q�X6��c�%�s��� �P�҃�7���KQ�9Gc`����<���A�������3s߂��=�n�3`h���5�Օ�WV���� V�
DHL>�2����gS�FQ���y#e*�"��H��w	�X���M���!�~��C�[�@�M����^�G�m���g㬰���V��k%橧�s���E��?m�	Bts��Z�����3��7_��o��?����������/0�`��;-�UX>!�-^�I$b�F�㹸y�1>�HDyE�B"�6�;��������߯�銷�[�F�I4MME�2D��n������m=��9E��6,Gu{[���/��h�N��߿ں�����W��R o��[���o�a���/_��?[����[OQ�?�p^�&y~�~���g�fX]����R���(����;���9�e�X�������F��>�{���?⭆�Di�m�qTf�#-���A���?h�u���`�
D��L�һi[mco\�l|�!BaY^���-F��D���N����$x.
���iʌ��B�ٝ��h�qYN�<�Ԅ:��#�@�j[x��	aHJ�\��r5�ɥĪDR��\.�=O�D%����ΕŢ[���W�f$�o�!u��A�}�;0Ns�猄pʥ�G5�ݬ�֤d����ҥXN��uTU5�-vY�׈�q�c�"s.ּ<����<5�}�+��{�i�'��E�*��0���MO/%��m��x��O+�y�c.�Ӣ���W��󽹘���R,T�A�<��9�T�q�8휤1�����y�Q8����t��(+��k�R���.�,q[>>�+=�<�Jǅ���B�^�2nN:�����y�Rj�����#"�P4��8J�B����F5y�F2Y�&��f+>!��l*��H�"��Yw��"y�f��j�n����[����\pbi4���侞���Z��:�ă�ܬ��P���O�Az�X���B�;�a�=88�V���ȣ�@�6�)�9�o����r!)�v$�\)���u�1��Y��O撉��U�w�_����\*YL*+��aq�[�q���D�-�Z*w��탣�{=%�mTO �#_&��D������s��ǵA=�O5#�\�"Č^�Ͱidɔ�ܠ�������za�Pf�a�O���b�,��	�K��1����p䗼����Xq��O������5���1�' �H�L�H�[��܆�(�7
w\�﫻C�E�O���i�������,y�wc�=>��r��p ��ԧT!��Gk�x���2�PGGm����䁡Fj�{J���:Sa��b�X��Z&�����ιdr�D�l�S�Q�X6��eFN�_]��^J3^5`�)�׻��QY

��>�U۩α^3�Z� '+b$]s���~��=�,t�B�)5^�f;��G���c��g�a���>���6>u�7���X��9�?�9�����d>�
.���@���x4v���#%}�%9>��L�&W3o
�m7b��M۔{ѧ�Qʜf
]	*n���[ϔ����仗���t�p��mup�$�M�]��i���\��)�ԣ���;���tX�R�᡼�5 �?�����&�k-��sh���\���e�a j(�4�!�f�z�c1�oCy�}���m��������C���T]�"�JVۦA�aK�U1e�pT�����!m����m|o��D�|�LR�|z�a+���<B�!P�{p7� i�'��.�W��n�HWL��Y�@�g<��5c@B���ѠA���G���2��"����������<���\<���YxD�c�o�}T�%�_s�tx�c���_�q�-��u:䥫�K�P��������D$�B82�����Z~}�B�Z��� ����g�jb\9�z����	I�//��L��{��������n��q��=�è��n������n۫'�+�"X-,��	'B� $HHhW ��V�#\����?��x>�̛�8�<��_���W�?��WUS�m���#|�L"E�X��6:\>��h� �`2T J���&�bB����*��P� �e$t�����G�����T�Ӌ'���ڏ~�F!��I�L��_��>Y(3c䌍�l2���9('��6]h�KЀ1�D���f>��>����,H��ϝ����I����w�{�5������ϟ�]�Ľ�XB�`�P�3�Oa{c�+���F�.�U�-�sr��c4�f��8��������3���N��L���4%��6�Bԉ 5$�:���G'�d�Ɩ�-r@�4[�$��%���3.�ޟ}���a�vO�
��И(�)�[k ��A�M���e}�2��:ppQKt����@q��ߖ��\dx��td=��a�6���-Vz�j���j�=!�gz�ȁo>�ʜ|��y�s����>,�&k2�Z�*��>~r���ej�o�D�"��KŇSk��JW��P����ځ���a�]~�Iwn2G�U�(*����eIY�eC��� ʰ�ʵ5��|��u�Dl�i�k6�t��й���n$�C2�'�TZ�*����s��G���9�p����S��w��W��E���.zf���Y�v����S�ps7:�I���2��<���Nĺz�O�c����?��>��|��]rz��O������O������0��{�'�s���W���?�~H�M�I�Ww^��ݷv�c��F;������X/������e%KF��ԋ%{�H:��d*)g HJ
��D"���0CB�)q9-uC���ד�������}��g�ο���`��G_��ߊߏ�~=����W�Z3�w����6�m�gC��p������|@|}��A�_������߿��h;b�@���)C0Vc�R��N7�-��)(	�i3,}Ĩ�ypV��j,}�,���-���W�UG`�N�P���c8 �� ��ܔ�NH+9;2//�p֞g��p�0m���4B(��.: ��H�ǢPl�i��c�ݚ�;��B�}�޶s4~V�lJ�M���Q�/��n�<�;gc�#n���w��q�ݢl)ߜ��K��v^�4,���g�Fb;�֪�Aڕ6æs�_�P.��å��u�-�������}�ɎuSW,:W)�Z���@"��\�<kP��L�כIH��rO�ElU��ҵB��a߫��@�1h��#��<����fmL,:�M�F�%=ƨ�Z��՚��~�29����H���!�)&�O�j���(�G�^|߄)�uȲN�jv19��3�iN,b�I��Vj&'��8�5�.�^��j�ϟ��f"	f�FӪ��Q�����X�[��?VD����������/����^�Mw�_wE_w_w�^w�^wE^w^w�]w�]wE]w]�0�W(�.�f�@GCo���d���*J�Eng�w;��D���lI%��ND�gG��n'��vV#p.���|I �s�C�D�о��!�﹝�I�X �|7�D��������~oYMNG�z>U���L��ߡ�1KKuZb�{��g9�ȴ
с,�Q3*�i휈h->�5A�S�u9S=�PQcl���%�w?��^���:���ҙx�&W�-O*QS�*�>[�T7%�I;֯�ۗ��]��3��r�LR��񄚰+&�d�ܨ�R3�"��i*1���I)E�X�\D._9:֒�N�2�V	9�cAo��e��tr�]�e��ެ��j�ַC���z�Qh'������v�F����/���v�ao��2�Ǿ f��pY4χ�ê�k�E���;;��x|w�]����&�r���޷�:�B;�.o����W�l�=B��I��x��7��{��?~s������~�A���(�Ϯ5e�%4e2X�|�J�*��1U��(s��IR�u/�| �l��c����M���9ǰ���@*�-q��Y��ӳ\�m���"�U�9�5]��i�O��Y�
2���@!JK�EF��΂gV�C`A2k1�jj̒�R�d6Y�g�U%wV#2�j�5;�3C�\Fx�]�׆�jG;�w�tv()]s���y'N��^ky2�U��*m'"]q�L�x�A۳H:�N�Q��N�t50"��i!,d�X�Y��1YH�r�1tX��f/��=�O�,�7Ρ�/�v�a�[4�,�#b�Q���2��ډ�TO�%����1��T|pR��IH�94�.�U�*�8b���3#�ו��lTj�g�x��z#<Y���x`�׮U�,
�%?P���a�ok´T�ҥ��N����?~���)0���K�rnI{2;,�=�H�Z��OX��	l{Q>�ev�(�L�4�O��ϸ����m��Sw��gtۭ��r��Ok���p"8�\c�3�2�V�j�T�WK�h;o���q���F�\
�ZZ�9VZ�܀�L��X�>�d(8�:��Uz�ֲg�p�L'��rY��-.\��ve�	��M�G���1ٚ���΅��֪q^��3U�M�S�����	]��2�s�X���W݀�5�O`z�=IW�|�X)Z�)��b#5+L���Cp��¼^�¨�O��� [�x.E����mq�L�#T$*fk	#]\֞�PL�W��DYD�d�r$By6��G'Zj*P�$�AL����j�a�iב�s^���]��6v&�m�`<gB���+�	��1ϙ�Q8�9"8�ޡ4��X�y�=ʎ�ͤިrD5q���\f��#�1�5�^+��uj^�r�}qL��4��p��JT9�7��q?ӗ��L#���y��:��([J�Yj��}�v>Z�@���Ȯ��Y�PK�)�y��
���
헴F���x1Q��S*!��H��d�Uz6$�z4�PFc�0��ݘ�#S0�l�Iέ�2���l\_��N��iTX��]�L~X[���C�p7��z'�3y���3E�`��y��#�Xݾ�az7�&�F���v�x�ƪuŴ&���,���
�h�W�SS\�������7MC7|�=��qm�����!����/�����۰��֣���4�pm��d���A>�g�{zertMv����/�O����k#��U��(�'\���)�7,�fhො�	�����{>9O��v-��43������t|�ץs��&��/��5翯?������Y�A����d����h�����s?�_�>~�\>��4��zJ�Z���s'אn�)w&aH
��c�e���{x�d��0�&90T,|��s"�7�UA�����ݝyH.�	k�k`��k�յin�*}��C�3�	�*�5�J]����r�l���?�f]�r�e�E�ה��9}��9�R��-��d����&������A�p A����ǸD�:�"�� z�{0
B>:�A�)��ฟ(8SjB�Lbt5�=��}�1{�@d�g~�����"95��hML�n:!I�";1�er�@����].?k�<u�%M-�`���Zc�X�$��3���>٢���	V�0���a��]��������uT�)�1� ��E�~�5�>�\��"Ӆnj�\�?��<변DA�'�M<l+6M�u!c`�ݦ��o�~!kc�g�:$�6�������9VF���C*0�1��G/�'ɭ� 
�m���@?$����2I�:U��_v'�/��H����F�ceS�ۛ�޽y�r�D�nߘ�m��ࣵ^@��z�T|į7�������@21L����/�[=�����t��=������//dp;�����%�o��r(sk��� >ĭ�\ 6o8������L���8\V�+��6�k}��3��D��l�j>	��	�l�3[����cd�*�o�DJ�!�]��(�d�80N���� -���2�0�3���f���E�=����� 8�S��D��Ϸ���^6�����1Hw�ĩ/"�'6:0��F7JJ��P�ȅRBy1����!5׹�Ug�������!�2�Q
sÚ�� ��s�cͣ�9)8y���!�k��p[��X�aS~6P{l����恐#��h	�y
};*�YXPȎ����J�
�po��:h��W&�a��UW;X�8�X�[p&M
L�vU}��-��^z�H�K���mA��q�� GX�["F�Á
�&�o��Z��l+y��]	$AE�#W"GHO%3c������x\cRr��=�PV�({3��\�C��&��!���c��3MES�6��0�DW�"�9���*h��S-d	�)�JKC>A��]����h��3��6&�n�G�/�8n���{5� �q�"�ɶ�}uv��7��W������Ĺ��k��'R�����x���������z+ħ�O	��D%[��pl%�h��&w�!���g��:G3u>{��O����o���-\����oe��R[��r�Wg9�t��W��u�Oщ�c嚂������Q�b��@J�2Q$bJ,�K&{ݮң�T� *�����,��^&	���IpjK��^`w��bŹg�������O>풟n��	yɧ0� 5_r�Vl�_`ρ�x1�TH��$)OGR2����F@ �L�3J*�N���dt��AI�3J<�P 	(��\ t���m��)��nC% ���O�� |x�ָ]��bv�l��6�!ᶉ���[�Q٭�^���:����se�N�NK�|�;�J�dE������+�,[��g_E.�F�6�����
�/�_C�]����K��]Ѩ,]U�}X ���uu�
Cs�v��y|8';���L�[a�@+kas���՟Jx0]�u����آ�h�����lgl_�����^p�λ(*�e "\,uSB���K$���)����w�^:ೕ:�Fy�/�O�W���y�@��l�]Q:J�rL3�Nz,�re�Z����H���a��:<��d:rë38@qNT�)�W. i=u�D�xui�nl%{�*1[)���i�[��� [��ӣ����B�t�Y��HS�UZ,\TTa_[V���y��!�"��ei�f��,�nCe�+賕f���]Ys�Z�}ׯ���=hn�W�iH ��rJb�$��/`;�!�c�[;q��S>���-���w�jMy�N���t����r����'�u˗�����>^�k��F�<��S�/�e��u�؏��/7��}O�����wMϖ��l��g���ϽZ����]{��e����l�n��˟=�6z�;��׏��9�ܝ�{g�/7�׻�iʿn�y�����.���/�/��ׇ���{��K����/4)P<�8��"a�
�s�o�;���������I�~����[֟�y�����[�o��Q���l���[Ɔ �����y�	p��"���u�����_�����/ç*����/���-���;���π��o��)���%`���;�@�!*�G��G1)�#A��3w�#���%A�IqĄ'0���q@F1��~�o�Qw���?�S���!�7�����_���J��2�,Ws���m�R�;ڔk��QFR޵��0�ۇ�^���ƕ�Y���a�׆{n�21���au��F_t'Sj8�;T����!����SN�I���kj�!�x?�'Ku�.ϵ����v��?�������CaH��p(��-�R��?
���4y'�� �� *��Aa`�_�����x����q� �����L��K���_8�S�m��?`���N�K!d�����p���[���Q /�����D������������	`N'��9�t	绀�����B�`��B��� ����X�?wS����?� ������(��Q��߾����K��VZcQtKټ.�b.���r��y*��34��S�g���I�����a��7�~^Z?���~�y�a,�F臷�}>�}3�������YZ2N��QYD�͸�,���eyw3\��Yc����tgr�U���Zi�S�b�j���j���o����}�Om�į�}V�l�R=�љ���� �:��W,������.g��z����S=n��;͔��'fF$qΝJ���oKɚU�(Ԇ�Fs��Fu0]���}��:ru)��u�w[�l�m븫��{�S�ےX�?8�/�k�(� ����[�a��p�_��p�B,��;�O��F��'���b��;�����t�@�Q���s�?,�������9�����	���?��������?��wtw�3y�Ӎ�=��yw�����+��>�����������㰞x�|�ݮ�k���`�?�s3����,��}�"v�&S�o-��Q�٦�IN�'I��Z������d�T�޲L=�����q},�r~����� Ք���O�΍���1>�t���c|��;�1�섮�h��Hbw?��xzk�x9�̡�U,F��U����<�[��绣Tf�'�WL��^�ȉE�z�8i�3{kh���/�B�Qw��0����f�m����s�?��yv/\����	p��hPB8�($y*�D.`E��$)�ɘ�@C1��y!�� $��9Fb2&aF�������?�N�������DY�˕���*�ۓtX/d����ڴb6IPU��mQ������>��8O��Q]�(u]%�㦷�m{.W�ŒQ�t+hI��Ms�m�}�WQ�.'\R�v�������8����Y
���9��
������?�����a`������8���og�zw��K�e?��y�/�%ޝ5�z��z�4�8]��?���-��&��D�c�ץ�U��̩<&F�3	U���,!;I�X������q�+�Ѯ�u����Ӱݷu�l��n�q��x��4����n��k�' ��/��*���_���_���Wl�4`�B�	�;KB����Ng���_���	�UUُw���<h�>����hZ���I����+�NJ����=3 ���@|�g�� 8Kհڛ�S��R%.C ^� ��ъ���\jf+�qZ-�9�#�]���F=7����q�NU=�t)�:����zT8���V=�wVo�v*Y�r1M�0'Ͼ�����W���]��z�`�%7�s<�U����'!O_10�E�r��$�ت�{���)��c� C�A�qZ�ź��T����JI�,��70��KM��2xx����P6u[5�^�llw�JY�v�S����FM�L�#�h.�?�lz�:����D��R9vV��Qexy�-Vf��g�/��A��r�8�����w���b��?�
|���P�/P��K��m���P��8�?M�9���$@����-P��/��s	�?
��?����?����DA�A@��(�x���dER����c6$}��}�g�X E^�?�.� |��#Q�Y!�|ޏ���ÀC������	~g���
v���v��b�ui��t�'���ٱ��'�2ٕ�ŏ��NG�Do��N��Ҩz�nS���C,��ZO�v�"i}l��c�'e��+�>�;��麴��oU��*�m�d��}-p��)����� �������o	�P����<MC����&�������h1�w��_4���M���9�˗���� ����;-@�^��������ok�Z���1*+��j LV�ln����B�5����ikL���������Q6����<���N��9��I��/�~Wwb��Tuvp�fo���`2l��\�kc���֕ڲ9���y���ܨ��3�p��	�:�D��Ԍ��c�c5��nWi�2[%.g�ڃ��emk���rne������Dl;�Y�Xl�'��ڒj�7't��������NdSwU�Vٴa�'��;�Y�?I\_*��^I�.v�}7�I{5*'F�p~����hUY�k_7rSv1虵�ON�*+	��r;2�e�Ȁ��;�=��[��?��+ �����?/;���������N�7O��@�7�C�7���?迏��<� ����s�?����r���Y \�E����� �G���_����b�������P����]z��EO�}�X������H���$y�3��(�����öP4��������]
�0�(������?u���?`��`Q ����������@���!P�����H ��� �t	ǻ����n�P���?�)�n���s7������C[H�!����������?���?��?迂��C��?��Â����0���`�X��w��@� �� ��b��;��� ��N(�/
�n���?���?�G������������C�?����!��������?
�
`��f�1�V��� ����8�?��^����S�Yd,����!ő(ţ��Pbi&f(�#��<��(�R@	�/�,�	��u��������� |��;F��OC>����9��*U2�/��NH�țM������,�	�%�H��V�?���-O����w�l�������v���tg���
�S�]��U)����ܣ��\esn�FW'�:�/��j�m�1�rYswǦV��"V���T��v7_���p�����8��gs8�-8���,��
��������/�'��_q���_;dL�P�ZݼRZ6�DVj�b�6mG�N��7+T��嵾��n<˜�3�Ne�U����؈&�f�c��vk�H�u���;�)��S=���CU޴7��n1���$�0v�f9m�u΂���c�����_D�`�����xm��P��_����������?������,X���~/������k]���_��R_���n��3���^T����J���߃��H;M��J���}H���Y7��l��%m?�6<�Ԇ� !kKDZ��O�Z�����ͤϓ���7�NҘ�S�tʤ͈I-�8i&��=��V׷R��ʉ[m�O�����t���v+Jn*�{a�$zE9���l/6�h_����[�}O��:e�z���!��5h1N+�X���6���۪Q���4s|��`0���_���šy�F�n'��͙א'��D����ʠ�d6�J�$ӫd]p�x�af��r�	�?o��;������-��g����&���O
4��"�G���߯\�o�
�p��(���'�#�G?�WG7(��(�����%)�p���n�Y�@������P��O�?����3���C���VWU�����ô�{�L��IIJ3��ys������h�������KWy�!㦝��Y�x����_S~�[�~<����9?;ד�3�<{���M%yJ]v.��K���ZB|k[���]%	3���5�j*J~)�s�K�v{aC]�R~�u��5���.m�*9[�j*�����l�Hh�T�).K��*sJ֤,~޸��O�n?!��x���|Е[G��5�w;�ç���yYs%ꗟeMn?���뛻��Z�T��D�%�DQ�m���؛�)�c��.s;���5�+Mc�j[b�f��,˜X5YSty�����*a�v���ו�Ж����\L��Rb$��-�J����_�����>��^�����ya_rZڼ���y�'`�����?8�E4�O82�)���H��/�����/�|(�H�&i~4
��F>#|ȅdH��!Ag�G����������	~g���'#��e;�=	�I�^����Ɵ���!�ۜ1�豧ď���r�[�B�E�\�
�����_��o8��.���}<p�����?��!��2������o��8�H�R��y������?#��n:Q�J�h�Bg�G��&��w���¼�XP���5�wI�o��;�����]R�+rSq�r����Sڏx]��f&�S��U��{Wڬ(�e��+�z/^�//�������<�L*���V�o�^3o�VeVV^�ҽ"2��p�u�>g�u�=��J���q�Gjt���˚�w�.&k�F�q���i�:��f�/��qA�a՜�g��X��+�t���q��rg�OՄ��p,j9�ؔ����0�*mw�lO��8��SV���l�?��:3���$�cם��Ș1�z�MB�4���q�#��m���_7q��<�&7Fyq�ZSy���.�7C48Ɍ������(��#���@�o&Ƞ��TZ'u��Vq�bV	"��������i���U��%{�D,�8E�N%[�j��o�,��??�Wy�������b�v}	7�"�6��r�	sc�,�A`���l�H�z�y��}ْ��[e��}-���O~�a��!p��E��ڻ��,��󯦵���c!���7���W~Ș�/60Td��8������&�����?h���T��n��o��j�Z{{p���w��q�������}����c���W��G��#�Ү�O��p��ק�f�l�/���œ�к�\!�:uu��B���\���kcq�M7���u^�k���R9��Q�L�^t��M��#�R8�w&�z��F����S�?���Y\�I���h�E�huח{�Wu��]tXz8�u:m!�c�e�m6���(\���,7/�>+���򖵦�Mm�~��-�q<Xs_f���i�r[�����KJ�ƪk��pЗm������3���P��h��e����r쪻E[h��V}DV��d���#k��)��a���
�cĈ�S۪r����2����{�C�O&Ȣ��U��
��[���a����%�C"h�P���6��!��;@�'�B�'���?迷���k�a�������_����C��FpC!����d7��g��7��7�����e�����{������?�A��
��̍�;�f�l��&�z�� ��?����㿙 /�O��w �?���O�7���SFȓ��" �������_p��,P�_�����9��d�d� ��x\B�aw���#���($@������_������P�����P�����!����� ��� �0��/k����������������	���o�����L ��� �����������y�б �?g@������O�����LP�����P����s��C�?��?.
��0�rB��om��h����[���+�M��?d�B�N8n`Z�YR�^#	�^jf�0H�T�f�JS5p��u��jj��"��1����[�tx��+�m�����U��ȓ$,*5��5���%�m�-q��4l���o��_^�B���XM��}��ϮA�����F�	��R]�I05�N8\ӟX��y{���գ�gv;qR��2Q�v�j�.,��%�����R!�JT�n(�=��,Q�h�㤅W�y��g�*o��fwT[cu_q>�{77�w�E����3?���G��-���C������������>%a`ޭ�(�C���g�ǩV����GL��!1�,�5��qǲ6�.��#q����k��&����]M�l'�.>��8��aS���ݞ�4*:�k�㥢r"�:E�z�[)SO]k)�������kQ����9!��_W���GlԿ
���_�꿠�꿠��@��4�0GB�Q�����������_����v�(��ڪ�<q$�2�����w�/�Ή�B�}m�}����m���6�Y��L��Q��":���p;U�ɲ�y�2S��<3�iyǄ��D��_K$�V���&��]{�.���W��j�<=Jh��:�k��E�]��ӯRD�uv���c��5Yg	"����e
����F����g-8��q"���涠�Y��J��Z�!�4��h>�ug�玳<�K��>�5B����6��[��q��-��j$��,VO�0�6�/����1�v'�&�4wu	S����:?��{�"�?�����������QPd��i�����0��'��=
��̝�/�?d��//^{�A��?���������C�g�\�?-˻������?~���2A���j������;��w�? �7���2{d����1��?� �?��#�?>.
���;㿠�2A��V���?��+�����0��?�B���m�/�������C�X�!G�Cw:\���:3��KS���PG���������ڏ�������s�G�a�_��HK?����������{���o _W�ۯ8Ѱ��θ�`�4O+��3�U��=rzh.k.�麘��e��z�i�4˻����G�ɆUsz���b9��LҲ_�[�~�e�ȝ�_Uήñ��cS*�2�D��ݱ�u<���pkOYy�>�M�~�/�̌Ӻ7�4|d�]w�c#cƐ�Y��wFih?t��XG��Y�Zw�ca�n��y�Mn���൦�J!Q]no�hp�{�8��0��r��ϻ-�?��+���n(�?��Q�LQ�������� ��������+������������x�M�����_!���sB����0 ��(D�����K�������Tv�m�aG����D�X��l�C����w���cɺOt�;����t-S�� ��5 �C�k�S@���J�ͪ\Wu�f�����a[V��]iLeh�("G�m���y8�ە���xlT踻���&c�	��5 HZ�Wj ����j 1Xٚ67e�&�l��C=Z-mC�=Y�IH�m1����i}^樰�v��XiD�P�A�{+��04�.k��wb��~�0��Q���Y���2A����"�y��c����E��
~��������d�dt�&��j���
�&�i4��aV�����`�I���F��K�~����GF������������#f�ҫj���g��D��#����`���b�Ec����?O��vF�̓U��@����g4�[���֔۾UQ���T�s�!ʫ�D�Q��i]�3�4�N�S[������(B����!��?]*�xp����/?��!�'7���/� &a`�M�(�C���g��O�������p�C��T�+��;�H��9�s��w����'j7����d������x�9�?:�	5�*Fk#ty�x�}���u%M'=���6�On�	���#	������o�T�A���Ƚ��UX 8G"��r�A��A������s�4`>(����
远�%�7M����-[��w�(Q�V�h�ü���{������j ��B �k �k+ܫ��v��/��3;��f�j���I��'򩆬ъ�ZT��D��Y0��JW)���R[M���W�ή�mV<�>*�T�q*7�/:�{�W��9�?n�q:&Jl,rq���^ �W0`�<�\?j��~�*y�XS���k���J�X���u�����'W��Gɏf��)ݡ>�s��a��^D>3�<�4a�nJ�����3���ފV�1{�X�S���X���V!yJ�C��l��OBsB(��l,��r<'xe^��v��O󿽍���w6˧��u}��#��	�$]������;����352J�^:�_�>��N��0���QId��̿�E�}�5~��7�#��cz�w~�5��Q�_~9݋T���	���n���}�m��������κ���|F�V=��\O�Fr�/G��'�/�_l��Z����_��}c|��>%����)���g|a���ϟ�N���{��?P��PMm�GI8:Qi�L'�����%?p���n6���2|BB#*�3�{�@�J�m��}ɑK'0�h���<�姟�Uҗ���d���F��W�6���/�/���T�ϟJ��gɏ�ɫ���[~MN��O�cY&��>ϗ�w��A��<��Mi���o}��/�[���Iۘ۠�8�F�1���.�D)ږ����0�����[��|a)��
���xVi�PT��]r�po�>%���ޏ���~������]��1t{[���{������woru��|]/�w�����F�=m�?o�_�/�x�-݉����(,!���5mnԈt���x���uz����~uO��Ż�'�w��� ޷�=��e鹣����a��wY��OJ��f�^�;��[���_�������    ���^<G � 