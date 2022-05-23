# Schema Registry DevOps
Showcase of using Schema Registry to verify schema evolution

This repo:
- Registers new schemas on commit merge to main branch
- Checks schema compatibility of evolution within a PR and ensures safe evolution

For this to work, the scripts assume each schema has a filename equal to the name of the corresponding topic/subject to check against.
