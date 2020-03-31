json.content_type "video"
json.created_at "2016-04-28T19:05:16.223Z"
json.urls do
  if current_user.is_a? Athlete
    json.mobile_url    "http://pros-telestream-staging.s3.amazonaws.com/088fdc70cae881dc3f503f25776df433.mp4"
    json.intro_url     "http://pros-telestream-staging.s3.amazonaws.com/2f975d432e8142c6320f5c69e37c56ff.mp4"
    json.share_url     "http://pros-telestream-staging.s3.amazonaws.com/f88fef4c29b13ab2e659923ff21b52ed.mp4"
    json.thumbnail_url "http://pros-telestream-staging.s3.amazonaws.com/088fdc70cae881dc3f503f25776df433_1.jpg"
  else
    json.mobile_url    "http://pros-telestream-staging.s3.amazonaws.com/088fdc70cae881dc3f503f25776df433.mp4"
    json.intro_url     "http://pros-telestream-staging.s3.amazonaws.com/2f975d432e8142c6320f5c69e37c56ff.mp4"
    json.share_url     "http://pros-telestream-staging.s3.amazonaws.com/f88fef4c29b13ab2e659923ff21b52ed.mp4"
    json.thumbnail_url "http://pros-telestream-staging.s3.amazonaws.com/088fdc70cae881dc3f503f25776df433_1.jpg"
  end
end
json.athlete do
  json.first_name "Chris"
  json.last_name "Voss"
  json.user_type "Athlete"
  json.avatar do
    json.thumbnail_url "https://s3.amazonaws.com/pros-staging/athlete/46/avatars/thumb/6b8392d725709ecf4da4bd31173b0ce9"
    json.medium_url    "https://s3.amazonaws.com/pros-staging/athlete/46/avatars/medium/6b8392d725709ecf4da4bd31173b0ce9"
    json.original_url  "https://s3.amazonaws.com/pros-staging/athlete/46/avatars/original/6b8392d725709ecf4da4bd31173b0ce9"
  end
end
json.reactions do
  json.array! [
    {
      content_type: "video",
      created_at: "2016-04-30T13:15:16.223Z",
      urls: {
        mobile_url:    "http://pros-telestream-staging.s3.amazonaws.com/2b462ac2e8ae5631b8a2a46fbc6275ec.mp4",
        intro_url:     "http://pros-telestream-staging.s3.amazonaws.com/22849a0203019bc9b1ccfadfa518f7ed.mp4",
        share_url:     "http://pros-telestream-staging.s3.amazonaws.com/87b998f89d769b19595dee5b0ed7a873.mp4",
        thumbnail_url: "http://pros-telestream-staging.s3.amazonaws.com/2b462ac2e8ae5631b8a2a46fbc6275ec_1.jpg",
      },
      athlete: {
        first_name: "Chelsea",
        last_name: "Powers",
        user_type: "Athlete",
        avatar: {
          thumbnail_url: null,
          medium_url:   null,
          original_url:  null
        }
      }
    },
    {
      content_type: "video",
      created_at: "2016-04-30T13:15:16.223Z",
      urls: {
        mobile_url:    "http://pros-telestream-staging.s3.amazonaws.com/84f556d10b7e34700dcfcadb8c5cc323.mp4",
        intro_url:     "http://pros-telestream-staging.s3.amazonaws.com/6e47e06871c31d27989b21b71f069268.mp4",
        share_url:     "http://pros-telestream-staging.s3.amazonaws.com/04aeb0c5590dad925a1fc4c20e055fad.mp4",
        thumbnail_url: "http://pros-telestream-staging.s3.amazonaws.com/84f556d10b7e34700dcfcadb8c5cc323_1.jpg",
      },
      athlete: {
        first_name: "Brandon",
        last_name: "Davis",
        user_type: "Athlete",
        avatar: {
          thumbnail_url: null,
          medium_url:   null,
          original_url:  null
        }
      }
    },
    {
      content_type: "video",
      created_at: "2016-04-30T13:15:16.223Z",
      urls: {
        mobile_url:    "http://pros-telestream-staging.s3.amazonaws.com/f6d6f69e3acbea135c3b532992c1e165.mp4",
        intro_url:     "http://pros-telestream-staging.s3.amazonaws.com/fc3368a479a643c02b425922d8ee1c5a.mp4",
        share_url:     "http://pros-telestream-staging.s3.amazonaws.com/72049379d592eb653666416ac428771c.mp4",
        thumbnail_url: "http://pros-telestream-staging.s3.amazonaws.com/f6d6f69e3acbea135c3b532992c1e165_1.jpg",
      },
      athlete: {
        first_name: "Chris",
        last_name: "Voss",
        user_type: "Athlete",
        avatar: {
          thumbnail_url: "https://s3.amazonaws.com/pros-staging/athlete/46/avatars/thumb/6b8392d725709ecf4da4bd31173b0ce9",
          medium_url:   "https://s3.amazonaws.com/pros-staging/athlete/46/avatars/medium/6b8392d725709ecf4da4bd31173b0ce9",
          original_url:  "https://s3.amazonaws.com/pros-staging/athlete/46/avatars/original/6b8392d725709ecf4da4bd31173b0ce9"
        }
      }
    }
  ]
end
json.comments do
  json.array! [
    {
      text: "I love this new app, Vernon.",
      created_at: Time.current-1.hour,
      athlete: {
        first_name: "Michael",
        last_name: "Young",
        user_type: "Athlete",
        avatar: {
          thumbnail_url: "https://s3.amazonaws.com/pros-production/athlete/2/avatars/thumb/3481703319_61a1b9b0c5_b.jpg",
          medium_url:   "https://s3.amazonaws.com/pros-production/athlete/2/avatars/medium/3481703319_61a1b9b0c5_b.jpg",
          original_url:  "https://s3.amazonaws.com/pros-production/athlete/2/avatars/original/3481703319_61a1b9b0c5_b.jpg"
        }
      }
    }
  ]
end
