```shell
# config gcloud
gcloud config set project leka-alpha-dev

# export data
gcloud firestore export gs://240417_leka_alpha_dev_bucket_backup --collection-ids=caregiver,patient

# import data
gcloud firestore import gs://240417_leka_alpha_dev_bucket_backup/2024-04-17T15:43:56_87853
```

```shell
# export auth users
firebase auth:export all_users.json --project leka-alpha-dev

# import
firebase auth:import ./all_users.json \
 --hash-algo=SCRYPT \
 --hash-key=tH95BVGdaaP6wu/wdEqrn0eFd2bu0YgSKlW3nxVlucfFJ9Z70YUUJSW9dEIUXskZt1kex02vJDFS2k7WDhosfg== \
 --salt-separator=Bw== \
 --rounds=8 \
 --mem-cost=14 \
 --project leka-app-dev
```

```js
hash_config {
  algorithm: SCRYPT,
  base64_signer_key: tH95BVGdaaP6wu/wdEqrn0eFd2bu0YgSKlW3nxVlucfFJ9Z70YUUJSW9dEIUXskZt1kex02vJDFS2k7WDhosfg==,
  base64_salt_separator: Bw==,
  rounds: 8,
  mem_cost: 14,
}
```

```shell
# new user id
evaOXjMsjBPFedJXMWf1
```

```shell
# export prepared data
gcloud firestore export gs://240417_leka_alpha_dev_bucket_backup/24_04_18-migration-1 --collection-ids=CAREGIVERS,CARE_RECEIVERS,ROOT_ACCOUNTS

# config gcloud
gcloud config set project leka-app-dev

# give permission
gsutil iam ch serviceAccount:service-749287588285@gcp-sa-firestore.iam.gserviceaccount.com:roles/storage.admin gs://240417_leka_alpha_dev_bucket_backup

# import prepared data
gcloud firestore import gs://240417_leka_alpha_dev_bucket_backup/24_04_18-migration-1 --collection-ids=CAREGIVERS,CARE_RECEIVERS,ROOT_ACCOUNTS


```
