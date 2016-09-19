#!/usr/bin/env bash
# author:mapengzhen

:<<!
参数解释:
        f:查找版本号
        r:升级小版本号 例:1.0.1 --> 1.0.2
        m:升级中位版本号 例:1.1.1 --> 1.2.1
        M:升级大版本号 例:1.0.1 --> 2.0.1
!

find_tag_version(){
    version=0
    file=$1
    if [[ -f ${file} ]]; then
        version=`cat ${file} |  grep '^ *s.version *=' | awk -F"[']" '{print $2}'`
    fi
    echo $version
}


change_version(){
    file=$1
    tag_location=$2
    version=`find_tag_version ${file}`
    new_version=`echo ${version} | awk -F"[.]" -v location=$tag_location '
        BEGIN{

        }
        {
        }
        END{
            if (location==1){
                printf("%d.%s.%s",$1+1,$2,$3);
            }else if(location==2){
                printf("%s.%d.%s",$1,$2+1,$3);
            }else if(location==3){
                printf("%s.%s.%d",$1,$2,$3+1);
            }
        }
    '`
    sed -i 'tmp' 's/'${version}'/'${new_version}'/g' $file
    rm -r "${file}tmp"
}

change_revision_version(){
    change_version $1 3
}

change_minor_version(){

    change_version $1 2
}

change_major_version(){

    change_version $1 1
}



while getopts :f:r:m:M:: ARGS
    do
        case $ARGS in
         f)
            param=$OPTARG
            find_tag_version $param
            ;;
         r)
            param=$OPTARG
            change_revision_version $param
            ;;
         m)
            param=$OPTARG
            change_minor_version $param
            ;;
         M)
            param=$OPTARG
            change_major_version $param
            ;;
         *)
            echo '''用法:

            '''
        esac
    done
