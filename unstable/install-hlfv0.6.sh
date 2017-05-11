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
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
if [ "$(uname)" = "Darwin" ]
then
  open http://localhost:8080
fi

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �<Y �[o�0�yx᥀!\�LL��R�@P������ɹ�l�w��2HHXW��4�?�\���9>��ؾ��H����Qc�:�wRz����]��3A���Ђ](t��n�:�v����R$#� P������5�J�H�}O�v�"D$�
� \䮩�${ ���`�q��A�yo�	����U��u��k��A	F����'Q�2 uP��nGd�ZjC^���ȋ���4��TM]����ҟ4^��x��2ڶ���b&ZjO�Z�B�M�B-��l-fk�mmfk�m�	�Y�HQ%c!I�1�UIӆK]K�4ҏk=W3���B���A��'��l&&i��k��vn���$+��t>1di%Ƀ�t���|~:��8���D+�`2g5<��ߪ��?�I��:���P&QY��P�ŝ��*���]�j�8X����C�!rݖ��p���B�~�ˀ���C&z��wbef++�x���s����_�z����c�.m�+xEv��-0���Ŗ4�H�-�Vq��o�|�; �qx�j�����7��c�U1�����C��LQ�Qsy��Qh�O0��11�&�ۋ�"*��\t>���t��'����]t�s�qȸE�M��M',N������]�2�nC�����/N�z)?�s� *jQB㸍ץz�,m��ﾘ8�q�b{���r���9��|��{&1o*�i�8-�ט<
���S�T�������W9���p8���p8���p8������V� (  