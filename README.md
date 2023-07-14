# ServiceNow API PowerShell Module
This PowerShell module provides the ability to interact with the ServiceNow API, allowing you to fetch and update incidents with ease.

## Functions

This module contains the following functions:

- `Connect-ServiceNow`: Establishes the connection to your ServiceNow instance.
- `Get-SNOWIncident`: Retrieves incidents based on given parameters.
- `Set-SNOWIncident`: Updates the state of a given incident.

## Usage

### `Connect-ServiceNow`

To connect to ServiceNow, use the `Connect-ServiceNow` function. This function prompts you for your ServiceNow URL and credentials, then authenticates and sets up your API endpoints.

```powershell
Connect-ServiceNow
```

### `Get-SNOWIncident`

To retrieve incidents, use the `Get-SNOWIncident` function with the desired switches. Here are some examples:

- To retrieve all open incidents assigned to you:

  ```powershell
  Get-SNOWIncident -ShowALLMyOpen
  ```

- To retrieve all resolved incidents assigned to you:

  ```powershell
  Get-SNOWIncident -ShowMyResolved
  ```

- To retrieve all open incidents:

  ```powershell
  Get-SNOWIncident -ShowALLOpen
  ```

- To retrieve all incidents:

  ```powershell
  Get-SNOWIncident -ShowALL
  ```

- To retrieve a specific incident by its incident number:

  ```powershell
  Get-SNOWIncident -IncidentNumber "INC0010002"
  ```

### `Set-SNOWIncident`

To update incidents, use the `Set-SNOWIncident` function. Here are some examples:

- To resolve a specific incident:

  ```powershell
  Set-SNOWIncident -ResolveIncident "INC0010002"
  ```

- To open a new incident:

  ```powershell
  Set-SNOWIncident -OpenIncident
  ```

- To close a specific incident:

  ```powershell
  Set-SNOWIncident -CloseIncident "INC0010002"
  ```

## Note

When resolving, opening, or closing incidents, you will be prompted to enter additional information, such as resolution notes, a short description, comments, or an assignee's email, depending on the operation.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
