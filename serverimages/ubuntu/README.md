# Setup Workload Identity Pool
```bash
export PROJECT_ID="<project-id>" # update with your project id value
```
```bash
gcloud iam service-accounts create "github-action-service-account" --project "${PROJECT_ID}"

gcloud services enable iamcredentials.googleapis.com --project "${PROJECT_ID}"

gcloud iam workload-identity-pools create "idp-pool" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --display-name="Idp pool"

gcloud iam workload-identity-pools describe "idp-pool" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --format="value(name)"
```
Set WORKLOAD_IDENTITY_POOL_ID from above command:

```bash
export WORKLOAD_IDENTITY_POOL_ID="projects/xxxxxxxxxx/locations/global/workloadIdentityPools/idp-pool"
```

```bash
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="idp-pool" \
  --display-name="Github provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

Update this value to your GitHub repository.


```bash
export REPO="<github-user-name>/gcp-packer" # username/reponame

gcloud iam service-accounts add-iam-policy-binding "github-action-service-account@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"


gcloud iam workload-identity-pools providers describe "github-provider" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="idp-pool" \
  --format="value(name)"
```

Use this value as the workload_identity_provider value in your GitHub Actions YAML.
Update ubuntu.pkrvars.hcl file under base folder to change packer settings. Like project id.

# Define Service Account Permissions To Run Packer

```bash
 gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member=serviceAccount:github-action-service-account@${PROJECT_ID}.iam.gserviceaccount.com \
    --role=roles/compute.instanceAdmin.v1

 gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member=serviceAccount:github-action-service-account@${PROJECT_ID}.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountUser

 gcloud projects add-iam-policy-binding "${PROJECT_ID}"\
    --member=serviceAccount:github-action-service-account@${PROJECT_ID}.iam.gserviceaccount.com \
    --role=roles/iap.tunnelResourceAccessor
```

# Run Packer Manually

Update ubuntu.pkvars.hcl file.


```bash
packer init -upgrade .
```

```bash
packer build -var-file=ubuntu.pkrvars.hcl .
```
