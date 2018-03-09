# mongorestore-s3

> Docker Image with Alpine Linux, mongorestore and awscli for restore mongo backup from s3

## Use

```bash
docker run --rm --name mongorestore \
  -v $(pwd)/backup:/backup \
  --env-file .env \
  doomsower/mongorestore-s3
```

It is required to mount volume to `/backup`

## Env varibales

| Name               | Required | Default Value    | Description 
|--------------------|----------|------------------|-------------
| BACKUP_PATH        |          | "" (empty string)| Path in buckket where to look for backup archive. Should not start with `/`, default empty string means backup archive in bucket root
| BACKUP_NAME        | Yes      |                  | Archive name, e.g. `wwdb_latest.tar.gz` 
| MONGO_URI          | Yes      |                  | [Mongo Connection String](https://docs.mongodb.com/manual/reference/connection-string/). E.g. `mongodb://localhost:27017/wwdb?ssl=false`
| MONGO_DB           | Yes      |                  | For some reason `--uri` alone is not enough, so this is mongo db name
| MONGO_OPTIONS      |          |                  | Extra options to pass to mongorestore, e.g. `-v --drop`
| MONGORESTORE_WAIT  |          |                  | If `true`, will use `--dryRun` first to wait until mongodb starts. Used to work with compose
| MONGORESTORE_HANG  |          |                  | If `true` will sleep infinitely after restore process is complete
| AWS_ACCESS_KEY     | Yes      |                  | AWS access key
| AWS_SECRET_KEY     | Yes      |                  | AWS secret key
| AWS_REGION         |          | eu-west-1        | AWS region
| S3_BUCKET          | Yes      |                  | AWS bucket name

## IAM Policity

You need to add a user with the following policies. Be sure to change `your_bucket` by the correct.

```xml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1412062044000",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket/*"
            ]
        },
        {
            "Sid": "Stmt1412062128000",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket"
            ]
        }
    ]
}
```

## License

[MIT](https://tldrlegal.com/license/mit-license)
