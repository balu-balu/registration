"""Vercel entry point — re-exports the Flask `app` from the project root."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from app import app  # noqa: F401  Vercel imports `app` from this module
