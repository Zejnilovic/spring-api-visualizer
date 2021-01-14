# Spring API Endpoints visualization

A simple collection of ruby scripts to collect data from `/actuator/mappings` and visualize all endpoint connections and the API "tree".

### Example

Exemple generatet using example project (PetClinic)[https://github.com/spring-projects/spring-petclinic].

![Alt text](examples/petclinic.png?raw=true "PetClinic example")

Added to `application.properties`
```
...
management.endpoints.enabled-by-default=true
...
```

This prijects `properties.conf`

```json
{
    "URL_BASE": "http://localhost:8080",
    "MAPPING_ENDPOINT": "/actuator/mappings",
    "CLASS_PREFIX": "org.springframework.samples.petclinic",
    "OUTPUT_FILE_NAME": "diagram.png"
}
```

## Settings

In the folder resources you need create a file called `properties.conf`.
This is expected to be a JSON with keys

- `"URL_BASE"` - Base url to your Spring app API
- `"MAPPING_ENDPOINT"` - actuator endpoint for mapping. If you did not change anything and just enabled it, then it is `"/actuator/mappings"`,
- `"LOGIN_ENDPOINT"` - endpoint for the login to your app. If you leave it empty then the script will skip logging in.
- `"CLASS_PREFIX"` - prefix of your controller classes. Your organization should suffice
- `"OUTPUT_FILE_NAME"` the name of the output file png

## Running

Spring app needs to be running

```shell
$> bundle install
$> rake run
```

## Testing

Not implemented yet. As this is more excercise project then an enterprise ready solution. but you can run `rake lint`

## ToDo

- how to add metadata like method, params, etc.?
- clean up the code
- add tests
