#!/usr/bin/env python
"""AFF4 objects for managing Chipsec responses."""

from grr.client.components.chipsec_support.actions import chipsec_types

from grr.lib import sequential_collection


class ACPITableDataCollection(
    sequential_collection.IndexedSequentialCollection):
  """A collection of ACPI table data."""
  RDF_TYPE = chipsec_types.ACPITableData
