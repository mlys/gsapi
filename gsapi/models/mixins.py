from schematics.models import Mixin
from schematics.types import StringType, IntType, LongType, BooleanType, URLType, EmailType
from schematics.types.compound import ListType, ModelType
from embed import Email, Note, Tel, Im, Pth, Review, Shr
from schematics.types.mongo import ObjectIdType
from bson import ObjectId
from tag import Tag
from rdt import Rdt

# mixins
# https://github.com/j2labs/schematics/blob/master/demos/mixins.py

# create
# RatingType() # https://developers.google.com/gdata/docs/2.0/elements#gdRating

# ResourceType() # https://developers.google.com/gdata/docs/2.0/elements#gdResourceId

class ModMixin(Mixin):
    count     = LongType()
    
    liked     = ListType(ObjectIdType(ObjectId))
    # create RatingType
    # https   ://developers.google.com/gdata/docs/2.0/elements#gdRating
    rating    = IntType()
    followers = ListType(ObjectIdType(ObjectId))
    favorited = ListType(ObjectIdType(ObjectId))
    
    reviews   = ListType(ModelType(Review))
    
    tags      = ListType(ModelType(Tag))
    
    tels      = ListType(ModelType(Tel), minimized_field_name='Telephones', description='')
    emails    = ListType(ModelType(Email), minimized_field_name='Emails', description='')
    ims       = ListType(ModelType(Im), minimized_field_name='Instant Message Network', description='')
    
    urls      = ListType(URLType(), minimized_field_name='Urls', description='Urls associated with this doc.')
    rdts      = ListType(ModelType(Rdt))
    desc      = StringType(minimized_field_name='Description')
    notes     = ListType(ModelType(Note))
    
    shrs      = ListType(ModelType(Shr), minimized_field_name='Share List', description='List of Share docs that describe who and at what level/role this doc is shared with.')
    
    # tos     : ie, parents
    tos       = ListType(ModelType(Pth))
    
    # frs     : froms, ie, children
    frCount   = IntType()
    frs       = ListType(ModelType(Pth))
    # question how to handle cases where number of frs/children exceed max doc size
    # frFs      = ModelType(GridFs)
