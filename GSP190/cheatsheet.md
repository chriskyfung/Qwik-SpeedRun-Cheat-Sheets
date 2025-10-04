# GSP190 IAM Custom Roles

_last updated_: 2021-09-18

## To create a custom role using a YAML file

```bash
gcloud iam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID

gcloud iam list-grantable-roles //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID

cat > role-definition.yaml <<EOF
title: "Role Editor"
description: "Edit access for App Versions"
stage: "ALPHA"
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
EOF

gcloud iam roles create editor --project $DEVSHELL_PROJECT_ID \
--file role-definition.yaml

gcloud iam roles create viewer --project $DEVSHELL_PROJECT_ID \
--title "Role Viewer" --description "Custom role description." \
--permissions compute.instances.get,compute.instances.list --stage ALPHA

```

> Create a custom role using a YAML file

> Create a custom role using flags

## To update a custom role using a YAML file

```bash
cat > new-role-definition.yaml <<EOF
description: Edit access for App Versions
etag: BwVxIAbRq_I=
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
- storage.buckets.get
- storage.buckets.list
name: projects/[PROJECT_ID]/roles/editor
stage: ALPHA
title: Role Editor
EOF

gcloud iam roles update editor --project $DEVSHELL_PROJECT_ID \
--file new-role-definition.yaml

gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--add-permissions storage.buckets.get,storage.buckets.list

```

> Update a custom role using a YAML file

> Update a custom role using flags

## Disabling a custom role

```bash
gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--stage DISABLED

gcloud iam roles delete viewer --project $DEVSHELL_PROJECT_ID

gcloud iam roles undelete viewer --project $DEVSHELL_PROJECT_ID

```

> Disabling a custom role

> Undeleting a custom role
