# docker-superset

> Version : 0.28.1

참고 :

```
https://github.com/amancevice/docker-superset/tree/master/examples/postgres
```

### .env 생성 ( .env_default 활용 )

    # MAPBOX 차트 활용 ( 필수 아님 )
    
    MAPBOX_API_KEY= [ GET KEY FROM MAPBOX ]
    
    # META DB 보안용
    
    SECRET_KEY= [ RANDOM LONG STRING ]
    
    # ADMIN USER 생성을 위함
    
    ADMIN_USER=  [ USER ID ]
    ADMIN_FNAME= [ FIRST NAME ]
    ADMIN_LNAME= [ LAST NAME ]
    ADMIN_EMAIL= [ EMAIL ]
    ADMIN_PW= [ PASSWORD]
    
### 컨테이너 생성 및 실행 

```
$ docker-compose up -d
```

### 추가 정보

script/docker-init.sh  :  USER 자동 생성 용도

