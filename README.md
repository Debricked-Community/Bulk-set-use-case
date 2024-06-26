Bulk Set Use Case
=================

This repository contains scripts to bulk set the Use Case for imported Debricked repositories.

To run the scripts you will to create an "Access Token" which can be found under "Admin tools -> Account settings" (it is recommended to create a token with Admin scope) 

To list all the available Use Cases execute:

```
.\AvailableUseCases.ps1 -AccessToken YOUR_ACCESS_TOKEN
```

then using the `id` of the Use Case you wish to set, execute:

```
.\SelectUseCase.ps1 -AccessToken YOUR_ACCESS_TOKEN -UseCaseId ID_TO_SET
```

this will try to find all of the repositories and set the use case appropriately.

Please note: during my testing some of the repositories produce a 403 error when trying to set a use case for some unknown reason.