# Build Docker Image

Goto cloudbuild/packer directory and run :

```bash
gcloud builds submit .
```

# Configuring Service Account for Packer

Below steps create an example Packer service account using `gcloud`.
Cloud Build will [impersonate Packer's service account](https://cloud.google.com/iam/docs/impersonating-service-accounts)
to run Packer acting as a given service account.

1. Set GCP project variables. Substitute `my-project` with your project identifier.

   ```sh
   export PROJECT_ID=my-project
   export PROJECT_NUMBER=`gcloud projects list --filter="$PROJECT_ID" --format="value(PROJECT_NUMBER)"`
   ```

2. Create Service Account for Packer

   ```sh
   gcloud iam service-accounts create packer --description "Packer image builder"
   ```

3. Grant roles to Packer's Service Account

   ```sh
   gcloud projects add-iam-policy-binding $PROJECT_ID \
     --role="roles/compute.instanceAdmin.v1" \
     --member="serviceAccount:packer@${PROJECT_ID}.iam.gserviceaccount.com"
   gcloud projects add-iam-policy-binding $PROJECT_ID \
     --role="roles/iam.serviceAccountUser" \
     --member="serviceAccount:packer@${PROJECT_ID}.iam.gserviceaccount.com"
   ```

4. Allow CloudBuild to impersonate Packer service account

   ```sh
   gcloud iam service-accounts add-iam-policy-binding \
     packer@${PROJECT_ID}.iam.gserviceaccount.com \
     --role="roles/iam.serviceAccountTokenCreator" \
     --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"

# Build Hardened Image With Packer

Goto serverimages directory and run:

For Hardened Ubuntu Image

```bash
 gcloud builds submit --config cloudbuild_ubuntu.yaml
```

For Hardened Rhel8 Image

```bash
 gcloud builds submit --config cloudbuild_ubuntu.yaml
```

For Hardened Rhel9 Image

```bash
 gcloud builds submit --config cloudbuild_ubuntu.yaml
```
