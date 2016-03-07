mcafee Cookbook
===============
This cookbook includes several recipes that will install various McAfee endpoint components such as:
DPC (Data Protection for Cloud)
VSE (VirusScan Enterprise)
MA  (McAfee Agent)

Requirements
------------

#### packages
- windows cookbook - needed to support windows platform deployments
- chef_handler - requirement of windows cookbook

depends is set in metadata.rb

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### mcafee::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mcafee']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### mcafee::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `mcafee` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mcafee]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
