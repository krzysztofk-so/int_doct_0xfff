
In order to trigger this job please either create PR and merge or directly push to the main branch.

I have defined jobs : build and test like it was in the requirments, all of the action will be run in dind, we need to use options: --privileged  and socket should be defined or port so docker daemon can properly run and build the image. 

We use dind as it keep proper isolation if the resources, each build job uses a fresh and clean environment to avoid dependencies or conflicts from the host system, 

I would define in the repository: "env.ECR_REPOSITORY" and "env.IMAGE_TAG" so during the CI it would use vales stored outside the repo and we do not need to have them in the configuration file. Also secret secrets.AWS_ACCESS_KEY_ID and secrets.AWS_SECRET_ACCESS_KEY will not be stored directly in the git repository.
