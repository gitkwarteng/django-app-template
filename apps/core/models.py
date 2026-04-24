from django.db import models
from django.utils import timezone


class TimestampedModel(models.Model):
    enabled = models.BooleanField("Enabled?", default=True, db_index=True)
    created_at = models.DateTimeField("Created", auto_now_add=False,
                                     default=timezone.now, db_index=True)
    updated_at = models.DateTimeField("Updated", auto_now=True,
                                      db_index=True)

    class Meta:
        abstract = True

    def save(self, *args, **kwargs) -> None:
        if not self.created_at:
            self.created_at = timezone.now()
        super().save(*args, **kwargs)

    def update(self, **kwargs):
        raw = kwargs.pop("raw", False)
        for field, value in kwargs.items():
            if hasattr(self, field):
                setattr(self,field,value)
        update_fields = list(kwargs.keys()) + ["updated_at"]
        if raw:
            self.save_base(raw=True, update_fields=update_fields)
        else:
            self.save(update_fields=update_fields)

