(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

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

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �<Y �]Y��ʶ���
��o��q�IQAAD�ƍ
f'AE���������*v�h��n43I�\��[+{e��d_��2���__� M��+J�����Bq!�<�Cq�����_Ӝ��dk;���Z��v��\��)�G�O|?�������4^f�2".�?E�T%�2��oS�_�C��_�-�����叒Rɿ\(����⊽w4\.��9�%���}��S���p����J�e�����/��t9��gLĝ��^u�=��ta�u��=�p'�4�ׯ�{+�_�ϙ�4B�����yNٔK�(M�(M�Iظ�E����OS$����Q����O�7�W��
�����?E���q}��q�x�!et������Ć��D^�ZO�M`���h�� ���@EYF�]6�/L�&����(ŵ`��l�ZЦ
3!���S>�A���U��,r�4A�8�:VblRzw��xn��E���uVz:��)K����ԍp7��A*�D������8�uY����G�D�ˁ/Ե�ߡScEUx�5���M�K������������?����J�g��.����:��xC���=��Z��R�@��nȒ�j�V��2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe���@�9��aRf�[7"��
��򸝢0i#��=də=Rg�A���o�(��0�ݏ�N4@�U���7��x�깑�S8b	��+��+���B3	�\��{�p��[��Q��܂���@��5�?W'Nc9xkcŝ4�s�kf�7�n$m,lq�0�U�����\�O�"��$ͽ������Nip�3m�P<Q(t�RP(@d���*F����͡]_�w#�L	��0{�nq��V�����Mm@;a���K�*nG(�JK�2qs��3���58O���=!98�ģȓ����/z^ .ԏ���4<�\XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋQW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����/8���2�I����x��ѧ���Z�x���Y��Nt��:PC��f{��W�d�%��'�s>��v<�3�H'B�~ƨ�*�3F}?��rd��A��`� �EZ��`����4E�w�����0EWrH<�0��'�5�%��;�b��V.�S^S�Q���lM�HM\L���C�f�?�e�.�i���ռ���ž�@h]�.?���gN�ȅ�D�=�5af[8�ȑ�[���9k@@H\^d��!��
 y;?U2�x-�cb��a�59p�k9�;�u]�����f�ڔ�Q"��0~:h=��E�Fѥ>��6s0!����8N�H�YD��M��_��~a(�v�7�6cyb|�M����u-�WS�ͬ��C��db<�?�/��~���I���?J����5�������"�����������s�_���	�����'�������2����JA�S�����'}�p�/�l��:N�l��a��a���]sY��(?pQ2@1g=ҫ��)�!�7�����P$]�e������qG��V�4��e��,��h\�o����b��Z6�`۶�17�ij��ɗ޲���f�V_r̹�4p�N�#ڃ967�hk�� ����V��(A��f)�Ӱ���(~i�e�O�_
>K���CT��T���_��W��}H�e�O�������(�3�*���/�gz����C��!|��l����;�f���w�бY��G�Ǧ��|h ���N���p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.&�R��;Y�c���'Zט#m�G��lp�H:����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2hBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��+�Ȋ����������KA��W����������k����-L�����%���_��������T�_���.���(��@�"�����%��16���ӏ:��O8C������빁[�8�(���H��>��,IRv�����_���V�e���?�	�"�Z�T��csbkL�6��s�U�����Г��b�J }'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߇�x�ǩ租~���?J��9x��$~����P�����B��~�L)\.�D��_
>*���_V�˟�w��	�L����b��(�V�K���������t��S�d��4B�?��9�m�.cS,���x.����a�G#�n�8K0A��6˰>Z-��2����������t����0Qx1�v�z���`�]��c��F����_\�Yh����8��u��RTO�È�<j̄�]��kF�A��!�Sn;�"l�z&⚠:����l�Z��0>s�����AW�_)��?�$���W�_���� ��h�
e���a���4��(>U�_x+��}�����?w�J���U�k,a	�0�������g��,	��3���s�#�J���.�j�u#}�F��;���@7�G�@CwA�h�A���vn�8P8��G`�t����t�v�#��ILW���	�<�-b�Zt3����������P�YOԉ5�����j�s�ފ���{�A3Q�t�r֓��ex�L>2�{Ġ��Ām���N��-���x�����E�ք~ހNQe�6�xN�/ݩ�۝�ؐ�����^��.uF$��m�,O7|���0�v�X���M�i����o�)��足��Y�9ˌ������mo9�� ����N�ʹ��\��ފ��>�[Z��>\d��BiH�?/�3��K��?`��De�������������5��'���[���i�?��I�tu�{)x�������q`�~��[����NS!�����������䙡��7P���F���>�}�my�@M�wM��-����yЃ!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4�:zz ��σ8��Х��cs �5�͑��hmւg�.��}{��Y#Yͥ.���d.���j�l��;�j��7|��N�aFHt��*�>=l<����O����� .����U�_)�-��Y�G���$|�����=(C�Y�?��ge�=���j��Z����ߩ�?t
���?�a��?�����uw1�cBW񟥠����+��s���X�����?�ￕ�������1%Q�q(�%\���"��� p���G	�X�
p�G(��������
e����g翜�?*���q����Lɖ�þeN�6;}�!Bs�m�me�E��#mѢ&/��1ќ��J;�����(���)�G�  �mow���c�o]�5�Oaz���z8#P�249�P�7�+u�Ŧ=4���|^������Qg��>Z|�3^��(�����_���,[?�
-���7�7e~���~���\9^j�id����d������b:��N�+���c���B��k��^$�t���N�x�����Z��&N���4�����.��Z�����ӍI���u��FH�����Ҋ��K�[-�Ԯ���O�Ż�])��Պ`��ko>��yh?:����e�|��y�+�v�`���o��]��N]�����G��%��}{�[���rmO�~z���bT���]ePQ��V�9O��1�n�]4��� �~�UQ����7D�.��ߑ�ӟK�}���F�+|?��������>w�z��8N����U��E�g_nl��ߓ����ŗ7K���Q��l/V`t�7E�p�xW{����ǒ�LZ�����q��q��Z�������۫��ݮ�����{�*�~����{,��-��JcK����y�Χ��ƛ��jp���0N���R���ƹ.T�O��#��k���O4a���"D~��j��Ծ���}��?��Y<���?W��7tñ�E��������w�F���Y��;{�@�Uő�}�n��ɦR��וU��f9�}�axgkxk�p�Y�gK�:{8�Ow��b�S���=�*�������u���p�\υˡ��2f��{�t]�ҡ"]�n;]�ukO׵ۺ���;1AM�	&����?1�OJ�F��|P	4bD!&������l;g�p� ���=]������=���{�'�1F69_�)7�2�B�Y"� c���.������d&K]J�#�0�[۲zL@u�$uD��L��p:�ǭ��7�r`��ѱ��b 6t/��5 h��s�3�ۄ�	�|��yGU�$����C��m��hNԍ��+��Ah�ef�tð��^��ŷ�q��)b�%#�ۊ�릮�ڽc�4 g�����z��~����3��dG:��B��LS�n9��A�T�lGj�C���9�����8sq\��CS1��ȬJ�?P��-��oֈ�9|r��xiȘeTx�oU�K��n5���h�,GS䃍��0�}��� mN�����L6��pz48���)�� ��w��#?��i>���:�:��g1�2���"�A�;�ʢ�sa�����1�I�Vc�2Ǻ���/dzI:�4�q���9���!���p�m���)U6ޅ5�}3��(��:wE�ft�~~W�{%*�Ʃ5�(���>.ifqt��h>_[߹��_֑*�Jc	2CJW�&o=�^��]�E.�k�-��"Ƀ[kgkfP�kN����~FhNf�~�_�Ԟk{�z&_G��j���cER�W<�<��s�����v�?I����ǜ�n ��!3�%8��t
�zaA3�6'f��a��;^k����$̕be仺j/Ɇ.�E�:|����Y^���,�:�'�����ㇳO3~hToHt./���1Y�po��n����7j��3��5�������	���ډ�Sk�����_���R�l#U���qU��l�E�������nl���h��z�}ժK0_�p~��p(�g���4�w������8�������~S��_���?�B�g(�[���3'�f�~�^��ݸ8��?:�2�9}��Ĺ���?y �1��ڧǛ�������Oq�z=��F�<����zt=֣��^�k�f����4?��=,����f6~��LW�X@t�@�l��fކݱD�-v�8J�3����yk;=d�B�ij�,�r̗���*���0M��<�e��zp���fn1/$>g�fN6t��$�g���9
SJt��0Q��i:KG;��zL���Dx�,�g��fQe��A_�46SE�E&�R�S�g�=J�7JyQ��a9Um	1!����`!�m�TU�X6�^/��8���K!
�ri?r��)�	k3am&�*LX��v;d ,�/�6�����]��[j�p��=5WB֭j��	��E�5%q�A@y��+�d��v�l��z\��Z���M�	��<�
m��h�H()f�d���	�8��̰ä�t93-8�v$�b-���u����X����&L�~`���X%�ZVj�X+��ҟ�E�,VӼx-�%�(i��i�yϰ�U��D�No'�B.H����!�c"�n���+K���e��3ʲ��l�R ˥�o�S)~w���i&?�|�G�E?õ��|�C�Y�կ��a��j�M*X�S����|*WVU�ܦ�,8#�y�(Q:\HUEӴ��㙖��S�=�3�K�%�z��GӾ!Ih]>F�
��i�:������MZ�SY�j1�݉*h?��U*���\�)�{�j��%�>WU\xo�%�HY�������WP�(����[.�����!A�M�I�3Ԛ����J��[xa�a5�+Ѣ���k'��r��7��FbRM 9�>����dM�"�Ue$�&�Jg���)��٥�6a�Ї�-V��i��
0�d�^�_k,!�ل��!��- ��lHꎏH���ʵ	)��ꞡ�&E�A	�'Y�4����i�l��f�l��l�p#ڧ9QpMA��yU�>�[�ڀ֠S��kWl����~��2y��� 9t�ۧ�Cg��_9]T�g+�*j�.p]�ms�_�;m�F�p���jj�������研,ոtt#��8^i�4:�q'���Ҽ�Vk�'Z�*�zB?÷���(<��'5Y�-'�֬M�6䡛��k`�ᇟC�>���j��ꜳЙ�� 0��~� n�<+�*f͡[��u�k��1u?��,��i��S\v���4�(z_�
|�<�2dV�0?�<���-N�U��9�� ���0�����1����!��8�������m}�~�K��R��K��ݣ���t�$�z���
A"�o��[����±/<h�#!Җ:����A�\t0���<�)�U,�Ypp�h��.88�0=��jMD�'�z�3��ᦇ��3�6�F�HzUQ�+�(G�[Z���8!��{��
���-"G��R���m�N'5����
�{LU������R�S`�����!<��1>~�!i��{��p�X8��I�A�����Lt��U]�Vb��L-G2�X��H_���w�	E�@%�W�ޖ��2Ά=Hvq�l�������?Іh'���^L�Du��5����m0M����pVn`��Tӊ�t���5�m�q��q������nӝ�[���ӆ?4vL�sL|�s �gwt�.x�T���V�]�w�a�����o�?9F��y�����xXv$�I[u�LG�F)\I"��rI&ZǼ� �S ��78�;X̠�`)*�q��g�"��8jPdR+0
�LWkʲ���al���`6¨M%��)e'.�Ƞ4F�)�)�S[� w�
Sb>ZvQ� �e�K�F�=\����`��E�t)%!TLG�����p�`�n,�(t��0�v�&Djl�ɷ�����!QW��m#(����K;� �{Ų�vG��W�R��'y9X(#.8�$����aFD�ʖ\�o��Ú�ؒp8��&K�Z�^�E��nw��%R�wi�=,�8l��3�Cy?�و�JN���N�L�B_+��V�m\��a��f��&�ZB��v�vG5��k���S���&^������k7��gȼ��y�>�).	���	A�8���n���+���sqT�J��8	�����܋�bv���o��j�pǧ��o������K/���?]k�]�{�^���4�NT?�2��޽���6��$��p<��~� �}��?���O?��o�����j��Oϟ��O��w��n]�����_�\��m^M'�U�����_�ɏ=���亂?���k�����7>�$�:^��?RП���/8�7g�����N��iS;m��M����W���W\; m�mj�M������f�l�j�����z���Uh�~p�0B�\���5�E��I�c �[������>�~�������kSԄ!�g`�u6����jJ�y�q�������<k�r�,�뵩i6�<-{Όm������i���8l�sf�0��S`.�̜��;DhmU��K=F2�q�K�ZW����Nv���޷�
B��  